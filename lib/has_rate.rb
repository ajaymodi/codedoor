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

  def client_rate_text
    rate_text(false)
  end

  def programmer_rate_text
    rate_text(true)
  end

  private

  def rate_text(is_programmer)
    case availability
    when 'part-time'
      "$#{is_programmer ? rate : hourly_rate_to_client} / hour"
    when 'full-time'
      "$#{is_programmer ? daily_rate_to_programmer : daily_rate_to_client} / day"
    else
      'Unavailable'
    end
  end

end
