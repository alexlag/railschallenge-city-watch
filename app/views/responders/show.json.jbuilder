json.responder do
  json.extract! @responder, :emergency_code, :type, :name, :capacity, :on_duty
end
