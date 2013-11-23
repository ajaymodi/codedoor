module RequireAccountRedirect
  protected

  # Redirects for users that haven't finished signing up for their client/programmer account
  def ensure_user_checked_terms
    account_required(nil)
  end

  def client_required
    account_required(:client)
  end

  def programmer_required
    account_required(:programmer)
  end

  def client_or_programmer_required
    account_required(:client_or_programmer)
  end

  def account_required(account)
    path = next_path_for_account(account)
    redirect_because_account_incomplete(path, account) if path
  end

  def next_path_for_account(account)
    if current_user.nil?
      login_path
    elsif !current_user.checked_terms?
      edit_user_path(current_user)
    elsif (account == :client) && current_user.client.nil?
      new_user_client_path(current_user)
    elsif (account == :programmer) && !current_user.completed_programmer_account?
      edit_user_programmer_path(current_user)
    elsif (account == :client_or_programmer) && current_user.client.nil? && !current_user.completed_programmer_account?
      # It's not obvious which account the user should redirect to, so use the heuristic that if they
      # clicked "Create Programmer Account", that they should finish building that account.
      current_user.programmer.present? ? edit_user_programmer_path(current_user) : new_user_client_path(current_user)
    end
  end

  def redirect_because_account_incomplete(path, account_type)
    if account_type == :client
      cookies[:after_client_signed_up_path] = request.fullpath
    elsif account_type == :programmer
      cookies[:after_programmer_signed_up_path] = request.fullpath
    else
      cookies[:after_account_signed_up_path] = request.fullpath
    end
    redirect_to path
  end

  # Redirect back to the page that forced the user to finish their account creation
  def client_signed_up_path
    path_from_cookie(:after_account_signed_up_path) || path_from_cookie(:after_client_signed_up_path) || programmers_path
  end

  def programmer_signed_up_path
    path_from_cookie(:after_account_signed_up_path) || path_from_cookie(:after_programmer_signed_up_path) || programmer_path(current_user.programmer)
  end

  def path_from_cookie(key)
    path = nil
    if cookies[key]
      path = cookies[key]
      cookies.delete(key)
    end
    path
  end
end
