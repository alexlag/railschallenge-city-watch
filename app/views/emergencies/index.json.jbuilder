json.emergencies do
  json.array!(@emergencies) do |emergency|
    json.extract! emergency, :code, :fire_severity, :police_severity, :medical_severity, :full_response, :resolved_at
  end
end

json.full_responses(@full_responses)
