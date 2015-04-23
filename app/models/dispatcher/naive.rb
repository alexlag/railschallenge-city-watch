module Dispatcher
  # Naive dispatcher, look through all possible combinations and picks best.
  # Complexity is something like O(2^n * n)
  class Naive < Dispatcher::Trivial
    # Looks for responders using trivial dispatcher first
    #
    # @param [Fixnum] severity severity to cover
    # @param [Array] responders responders to search
    # @return [Array] dispatched responders
    def self.look_for(severity, responders = [])
      # Try trivial first
      super
      rescue NoDispatchError
        naive_look_for(severity, responders)
    end

    # Looks through every possible combination
    #
    # @param [Fixnum] severity severity to cover
    # @param [Array] responders responders to search
    # @return [Array] dispatched responders
    def self.naive_look_for(severity, responders)
      # This is slow, but somewhat readable:
      #   for each combination calculate summary of capacities,
      #   then pick the closest to 0 from fully covering ones
      candidates(responders)
        .map { |combination| diff(severity, combination) }
        .reject { |x| x[:diff] < 0 }
        .sort { |x, y| x[:diff] <=> y[:diff] }
        .first[:combination]
      rescue
        raise NoDispatchError
    end

    # Builds every possible combination of responders (2^N)
    #
    # @param [Array] responders
    # @return [Array] all combinations of responders
    def self.candidates(responders)
      (1..responders.size)
        .flat_map { |n| responders.combination(n).to_a }
    end

    # Builds utility hash with score of how closely combination of responders are covering severity
    #   and combination itself
    #
    # @param [Fixnum] severity severity to cover
    # @param [Array] responders combination of responders
    # @return [Hash] score and combination
    def self.diff(severity, responders = [])
      {
        diff: sum_capacity(responders) - severity,
        combination: responders
      }
    end
  end
end
