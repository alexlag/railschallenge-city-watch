class Emergency < ActiveRecord::Base
  SEVERITY_TYPES = %w(fire police medical)

  validates :code, presence: true, uniqueness: true

  SEVERITY_TYPES.each do |type|
    validates "#{type}_severity", presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  has_many :responders, dependent: :nullify

  scope :full_responses, -> { where(full_response: true) }

  def self.full_responses_info
    [full_responses.count, all.count]
  end

  def dispatch_and_save!
    responders << SEVERITY_TYPES.flat_map do |type|
      look_for_responders(send("#{type}_severity"), type.capitalize)
    end

    save!
    self.full_response = full_response?
    save!
  end

  def clean_and_update(params)
    params[:responders] = [] if params[:resolved_at]
    update(params)
  end

  def full_response?
    SEVERITY_TYPES.all? do |type|
      responders.to(type.capitalize).sum_capacity >= send("#{type}_severity")
    end
  end

  private

  def look_for_responders(severity, type)
    responders = Responder.to(type).available_on_duty
    return [] if responders.empty?

    # Pick desired dispatcher
    Dispatcher::Naive.look_for(severity, responders)
    rescue Dispatcher::NoDispatchError
      []
  end
end
