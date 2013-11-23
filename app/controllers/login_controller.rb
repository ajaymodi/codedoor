class LoginController < ApplicationController
  def main
    redirect_to root_path if user_signed_in?
  end
end
