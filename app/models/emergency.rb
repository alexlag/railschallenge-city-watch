class Emergency < ActiveRecord::Base
  SEVERITY_TYPES = %w(fire police medical)

  validates :code, presence: true, uniqueness: true

  SEVERITY_TYPES.each do |type|
    validates "#{type}_severity", presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  has_many :responders, foreign_key: :emergency_code, primary_key: :code, dependent: :nullify

  before_save :free_responders

  def self.full_responses
    where(full_response: true)
  end

  def self.full_responses_info
    [full_responses.count, all.count]
  end

  def dispatch_and_save!
    responders << SEVERITY_TYPES.flat_map do |type|
      EmergencyHelper.look_for_responders(send("#{type}_severity"), type.capitalize)
    end

    save!
    self.full_response = full_response?
    save!
  end

  def full_response?
    SEVERITY_TYPES.all? do |type|
      responders.to(type.capitalize).sum_capacity == send("#{type}_severity")
    end
  end

  private

  def free_responders
    self.responders = [] if resolved_at
  end
end
