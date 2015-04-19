class Responder < ActiveRecord::Base
  # To avoid STI from :type column
  self.inheritance_column = nil

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: { in: (1..5) }

  belongs_to :emergency, foreign_key: :emergency_code, primary_key: :code

  scope :of_type, ->(type) { where(type: type) }
  scope :available, -> { where(emergency_code: nil) }
  scope :on_duty, -> { where(on_duty: true) }
  scope :available_on_duty, -> { available.on_duty }

  # Array of types in system
  def self.types
    uniq.pluck(:type)
  end

  # Summarizes capacity in scope
  def self.sum_capacity
    pluck(:capacity).reduce(0, :+)
  end

  # Makes array of metrics for given type
  def self.capacity_info_for(type)
    if type
      filtered = of_type(type)
      [
        filtered.sum_capacity,
        filtered.available.sum_capacity,
        filtered.on_duty.sum_capacity,
        filtered.available_on_duty.sum_capacity
      ]
    end
  end

  # Gathers capacity information for each type in system
  def self.capacity_info
    types.each_with_object({}) do |type, result|
      result[type] = capacity_info_for(type)
    end
  end
end
