module EmergencyHelper
  # Check dispatchers/*.rb
  def self.look_for_responders(severity, type)
    responders = Responder.to(type).available_on_duty
    return [] if responders.empty?
    # Pick desired dispatcher
    NaiveDispatcher.look_for(severity, responders)
  end
end
