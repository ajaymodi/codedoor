module ApplicationHelper
  def model_has_error?(model, attribute)
    model.errors.has_key?(attribute)
  end

  def model_attribute_class(model, attribute)
    model_has_error?(model, attribute) ? 'error' : ''
  end

  def model_attribute_class_array(model, attribute_array)
    attribute_array.each do |attribute|
      return 'error' if model_has_error?(model, attribute)
    end
    ''
  end

  def model_error_message(model, attribute)
    return '' unless model_has_error?(model, attribute)
    messages = model.errors.messages[attribute]
    messages.empty? ? '' : "#{attribute.to_s.humanize} #{messages.to_sentence}."
  end

  def repo_commits_link(username, repo_owner, repo_name, text)
    link_to(text, GithubRepo.repo_commits_url(username, repo_owner, repo_name), target: '_blank')
  end

  # The rate object can be a programmer or job
  def client_rate_text(rate_object)
    rate_text(rate_object, false)
  end

  def programmer_rate_text(rate_object)
    rate_text(rate_object, true)
  end

  private

  def rate_text(rate_object, viewing_as_programmer)
    case rate_object.availability
    when 'part-time'
      rate = viewing_as_programmer ? rate_object.hourly_rate : rate_object.hourly_rate_to_client
      # If the rate happens to be a certain number of dollars, do not include cents.  Otherwise, include cents.
      "#{number_to_currency(rate, precision: rate.to_i.to_f == rate ? 0 : 2)} / hour"
    when 'full-time'
      rate = viewing_as_programmer ? rate_object.daily_rate_to_programmer : rate_object.daily_rate_to_client
      "#{number_to_currency(rate, precision: rate.to_i.to_f == rate ? 0 : 2)} / day"
    else
      'Unavailable'
    end
  end
end
