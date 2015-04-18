class Responder < ActiveRecord::Base
  self.inheritance_column = nil

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: { in: (1..5) }
end
