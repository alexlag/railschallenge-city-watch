json.emergencies do
  json.array!(@emergencies) do |emergency|
    json.extract!(emergency, *Emergency::SEVERITY_FIELDS, :code, :full_response, :resolved_at)
  end
end

json.full_responses(@full_responses)
