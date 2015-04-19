module EmergencyHelper
  # This looks like Subset Sum Problem
  class TrivialDispatcher
    def self.look_for(severity, responders = [])
      # Trivial: no severity
      return [] if severity == 0
      # Trivial: there is a responder with exact capacity
      responders.each do |responder|
        return [responder] if responder.capacity == severity
      end if severity <= 5

      # Trivial: total capacity <= severity
      return responders if sum_capacity(responders) <= severity
      nil
    end

    # A bit of copy-paste
    def self.sum_capacity(responders = [])
      return 0 if responders.empty?
      responders.map(&:capacity).reduce(0, :+)
    end
  end

  class NaiveDispatcher < TrivialDispatcher
    def self.look_for(severity, responders = [])
      # Naive, O(2^n * n)
      # This is slow, but somewhat readable
      super ||
        candidates(responders)
          .map { |combination| diff(severity, combination) }
          .reject { |x| x[:diff] < 0 }
          .sort { |x, y| x[:diff] <=> y[:diff] }
          .first[:combination]
    end

    def self.candidates(responders)
      (1..responders.size)
        .flat_map { |n| responders.combination(n).to_a }
    end

    def self.diff(severity, responders = [])
      {
        diff: sum_capacity(responders) - severity,
        combination: responders
      }
    end
  end
end
