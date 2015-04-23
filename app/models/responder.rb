class Responder < ActiveRecord::Base
  # To avoid STI from :type column
  self.inheritance_column = nil

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: { in: (1..5) }

  belongs_to :emergency
  delegate :code, to: :emergency, allow_nil: true, prefix: true

  scope :to, ->(type) { where(type: type) }
  scope :available, -> { where(emergency_id: nil) }
  scope :on_duty, -> { where(on_duty: true) }
  scope :available_on_duty, -> { available.on_duty }

  # @return [Array] Types in the system
  def self.types
    uniq.pluck(:type)
  end

  # @return [Fixnum] Sum of capacities in scope
  def self.sum_capacity
    pluck(:capacity).reduce(0, :+)
  end

  # Makes array of metrics for given type
  #
  # @param [String] type one of types in the system
  # @return [Array] Numbers of responders according to specs
  def self.capacity_info_for(type)
    if type
      typed = Responder.to(type)
      [typed, typed.available, typed.on_duty, typed.available_on_duty].map(&:sum_capacity)
    end
  end

  # Gathers capacity information for each type in system
  #
  # @return [Hash] Responder information for each type
  def self.capacity_info
    types.each_with_object({}) do |type, result|
      result[type] = capacity_info_for(type)
    end
  end
end
