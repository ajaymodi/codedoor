module HasRate
  def daily_rate_to_programmer
    rate.nil? ? nil : (rate * 8)
  end

  def daily_rate_to_client
    rate.nil? ? nil : (rate * 9)
  end

  def hourly_rate_to_client
    rate.nil? ? nil : (rate * 9.0 / 8.0).round(2)
  end

  def daily_fee_to_codedoor
    rate.nil? ? nil : rate
  end

  def hourly_fee_to_codedoor
    rate.nil? ? nil : (rate / 8.0).round(2)
  end

end
