class Emergency < ActiveRecord::Base
  # Severity related fields are extracted from migration assignements
  # like ['fire_severity', 'medical_severity', 'police_severity']
  SEVERITY_FIELDS = column_names.select { |col| col.ends_with?('severity') }.freeze

  # Validation for each severity requirement
  validates(*SEVERITY_FIELDS, presence: true, numericality: { greater_than_or_equal_to: 0 })

  validates :code, presence: true, uniqueness: true

  has_many :responders, dependent: :nullify

  scope :full_responses, -> { where(full_response: true) }

  # Info about total full responses
  #
  # @return [Array] How many emergencies had been fully responded, Total amount of emergencies
  def self.full_responses_info
    [full_responses.count, all.count]
  end

  # Custom save method that fills responders according to dispatcher,
  #   counts if that covers emergency fully and then saves
  #
  # @return [Emergency] Dispatched and saved to DB emergency
  def dispatch_and_save!
    responders << SEVERITY_FIELDS.flat_map do |field|
      type = get_type_from(field)
      look_for_responders(attributes[field], type)
    end

    save!
    self.full_response = full_response?
    save!
  end

  # Frees responders if emergency is resolved
  #
  # @param [Hash] params new parameters for update
  # @return [Emergency] Updated emergency
  def clean_and_update(params)
    params[:responders] = [] if params[:resolved_at]
    update(params)
  end

  # Calculates if emergency has its severities fully covered ATM.
  #
  # @return [Boolean]
  def full_response?
    SEVERITY_FIELDS.all? do |field|
      type = get_type_from(field)
      responders.to(type).sum_capacity >= attributes[field]
    end
  end

  private

  # Looks for responders, who can cover severity, for given type
  #
  # @param [Fixnum] severity severity to cover
  # @param [String] type type of responders to look for
  # @return [Array] dispatched responders
  def look_for_responders(severity, type)
    responders = Responder.to(type).available_on_duty
    return [] if responders.empty?

    # Pick desired dispatcher
    Dispatcher::Naive.look_for(severity, responders)
    rescue Dispatcher::NoDispatchError
      []
  end

  # Converts severity column name to type used in responders
  #   'fire_severity' -> 'Fire'
  #
  # @param [String] field severity field name
  # @return [String] capitalized type
  def get_type_from(field)
    field.split('_').first.capitalize
  end
end
