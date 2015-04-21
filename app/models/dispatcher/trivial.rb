module Dispatcher
  class Trivial
    def self.look_for(severity, responders = [])
      # Trivial: no severity
      return [] if severity == 0
      # Trivial: there is a responder with exact capacity
      responders.each do |responder|
        return [responder] if responder.capacity == severity
      end if severity <= 5

      # Trivial: total capacity <= severity
      return responders if sum_capacity(responders) <= severity

      fail NoDispatchError
    end

    # A bit of copy-paste
    def self.sum_capacity(responders = [])
      return 0 if responders.empty?
      responders.map(&:capacity).reduce(0, :+)
    end
  end

  class NoDispatchError < StandardError
    # Raised if dispatcher failed
  end
end
