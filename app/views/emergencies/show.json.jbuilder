json.emergency do
  json.extract! @emergency, :code, :fire_severity, :police_severity, :medical_severity, :resolved_at
end
