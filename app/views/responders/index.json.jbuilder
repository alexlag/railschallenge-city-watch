json.responders do
  json.array!(@responders) do |responder|
    json.extract! responder, :emergency_code, :type, :name, :capacity, :on_duty
  end
end
