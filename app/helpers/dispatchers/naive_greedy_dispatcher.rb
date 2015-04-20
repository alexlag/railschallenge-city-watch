class NaiveGreedyDispatcher < TrivialDispatcher
  # Naive, O(2^n * n), picks first succesful dispatch
  def self.look_for(severity, responders = [])
    # Try trivial first
    super
    rescue NoDispatchError
      # This is a bit faster than Naive, but not optimal
      candidates(responders)
        .map { |combination| diff(severity, combination) }
        .find { |computed| computed[:diff] >= 0 }[:combination]
    rescue
      raise NoDispatchError
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
