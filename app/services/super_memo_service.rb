class SuperMemoService
  def next_interval(quality, easiness_factor, previous_interval)
    if previous_interval.nil?
      1
    elsif previous_interval==1
      6
    else
      previous_interval*get_new_ef(easiness_factor, quality)
    end
  end

  def get_new_ef(ef, q)
    ef+(0.1-(5-q)*(0.08+(5-q)*0.02))
  end
end
