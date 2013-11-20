module HasRate
  def daily_rate_to_programmer
    hourly_rate.nil? ? nil : (hourly_rate * 8)
  end

  def daily_rate_to_client
    hourly_rate.nil? ? nil : (hourly_rate * 9)
  end

  def hourly_rate_to_client
    hourly_rate.nil? ? nil : (hourly_rate * 9.0 / 8.0).round(2)
  end

  def daily_fee_to_codedoor
    hourly_rate.nil? ? nil : hourly_rate
  end

  def hourly_fee_to_codedoor
    hourly_rate.nil? ? nil : (hourly_rate / 8.0).round(2)
  end

end
