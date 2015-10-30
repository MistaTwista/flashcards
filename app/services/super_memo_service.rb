class SuperMemoService
  def next_step(quality, easiness_factor, previous_interval)
    if previous_interval.nil?
      new_i = 1
    elsif previous_interval == 1
      new_i = 6
    else
      new_ef = get_new_ef(easiness_factor, quality)
      new_i = previous_interval * new_ef
    end
    new_ef = 2.5 if new_ef.nil?
    { new_i: new_i.round, new_ef: new_ef }
  end

  def get_new_ef(ef, q)
    new_ef = ef + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
    if new_ef > 1.3
      new_ef
    else
      1.3
    end
  end
end
