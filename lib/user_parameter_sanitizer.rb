class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params.permit(:username, :email, :full_name, :country, :state, :city, :password, :password_confirmation, :checked_terms)
  end
end
