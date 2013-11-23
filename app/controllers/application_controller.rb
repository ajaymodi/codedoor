class ApplicationController < ActionController::Base
  include RequireAccountRedirect

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization
  skip_authorization_check

  # TODO: remove hack to make CanCan work with Rails 4
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_cannot_be_found
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_cannot_be_found
  end

  def main
    @custom_description = 'CodeDoor is a marketplace for freelance programmers that have contributed to open source software.'
    render('loggedout') unless current_user.present?
  end

  def after_sign_in_path_for(resource)
    if cookies[:after_client_signed_up_path].present?
      next_path_for_account(:client) || path_from_cookie(:after_client_signed_up_path)
    elsif cookies[:after_programmer_signed_up_path].present?
      next_path_for_account(:programmer) || path_from_cookie(:after_programmer_signed_up_path)
    else
      next_path_for_account(:client_or_programmer) || path_from_cookie(:after_account_signed_up_path) || root_path
    end
  end

  protected

  def redirect_cannot_be_found
    redirect_to root_url, alert: 'Information cannot be found.'
  end

  def devise_parameter_sanitizer
    if resource_class == User
      User::ParameterSanitizer.new(User, :user, params)
    else
      super # Use the default one
    end
  end

end
