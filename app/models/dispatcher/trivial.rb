module Dispatcher
  # Dispatcher, that covers trivial cases
  class Trivial
    # Looks for responders using some heuristics
    #
    # @param [Fixnum] severity severity to cover
    # @param [String] type type of responders to look for
    # @return [Array] dispatched responders
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

    # Sums capacity across given responders
    #   A bit of copy-paste
    #
    # @param [Array] responders
    # @return [Fixnum] Sum of capacities
    def self.sum_capacity(responders = [])
      return 0 if responders.empty?
      responders.map(&:capacity).reduce(0, :+)
    end
  end
end
