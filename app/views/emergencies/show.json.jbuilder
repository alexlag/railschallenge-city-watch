json.emergency do
  json.extract!(@emergency, *Emergency::SEVERITY_FIELDS, :code, :full_response, :resolved_at)
  json.responders(@emergency.responders.map(&:name))
end
