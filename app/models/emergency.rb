class Emergency < ActiveRecord::Base
  include EmergencyHelper
  SEVERITY_TYPES = %w(Fire Police Medical)

  validates :code, presence: true, uniqueness: true

  SEVERITY_TYPES.map(&:downcase).each do |type|
    validates "#{type}_severity", presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  has_many :responders, foreign_key: :emergency_code, primary_key: :code, dependent: :nullify

  before_save :free_responders

  def self.full_responses
    all.select { |emergency| emergency if emergency.full_response }
  end

  def self.full_responses_info
    [full_responses.count, all.count]
  end

  def dispatch_and_save!
    responders << SEVERITY_TYPES.flat_map do |type|
      NaiveDispatcher.look_for(send("#{type.downcase}_severity"), Responder.to(type).available_on_duty)
    end

    save!
    self.full_response = full_response?
    save!
  end

  def full_response?
    SEVERITY_TYPES.all? do |type|
      responders.to(type).sum_capacity == send("#{type.downcase}_severity")
    end
  end

  private

  def free_responders
    self.responders = [] if resolved_at
  end
end
