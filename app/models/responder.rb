class Responder < ActiveRecord::Base
  self.inheritance_column = :type
end
