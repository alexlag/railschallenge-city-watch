class NaiveDispatcher < TrivialDispatcher
  # Naive, O(2^n * n)
  # This is slow, but somewhat readable
  def self.look_for(severity, responders = [])
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
