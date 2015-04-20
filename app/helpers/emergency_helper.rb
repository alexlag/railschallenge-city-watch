class NoDispatchError < StandardError
  # Raised if dispatcher failed
end

module EmergencyHelper
  # Check dispatchers/*.rb
  def self.look_for_responders(severity, type)
    responders = Responder.to(type).available_on_duty
    return Responder.none if responders.empty?

    # Pick desired dispatcher
    NaiveDispatcher.look_for(severity, responders)
    rescue NoDispatchError
      Responder.none
  end
end
