class Emergency < ActiveRecord::Base
  # Severity related fields are extracted from migration assignements
  SEVERITY_FIELDS = column_names.select { |col| col.ends_with?('severity') }

  validates :code, presence: true, uniqueness: true

  SEVERITY_FIELDS.each do |field|
    validates field, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end

  has_many :responders, dependent: :nullify

  scope :full_responses, -> { where(full_response: true) }

  def self.full_responses_info
    [full_responses.count, all.count]
  end

  def dispatch_and_save!
    responders << SEVERITY_FIELDS.flat_map do |field|
      type = field.split('_').first.capitalize
      look_for_responders(attributes[field], type)
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
    SEVERITY_FIELDS.all? do |field|
      type = field.split('_').first.capitalize
      responders.to(type).sum_capacity >= attributes[field]
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
