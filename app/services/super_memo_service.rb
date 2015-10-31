class SuperMemoService
  def next_step(correct, time, easiness_factor, previous_interval)
    q = 0
    q = quality_from_timer(time) if correct
    if previous_interval.nil?
      new_i = 1
    elsif previous_interval == 1
      new_i = 6
    else
      new_ef = get_new_ef(easiness_factor, q)
      new_i = previous_interval * new_ef
    end
    { new_i: new_i.round, new_ef: new_ef }
  end

  def quality_from_timer(time)
    if time.to_i > SECONDS_TO_ANSWER[:slow]
      3
    elsif time.to_i > SECONDS_TO_ANSWER[:fast]
      4
    else
      5
    end
  end

  def get_new_ef(ef, q)
    if ef.nil?
      return 2.5
    end
    new_ef = ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    if new_ef > 1.3
      new_ef
    else
      1.3
    end
  end
end
