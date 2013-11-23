class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    auth = request.env['omniauth.auth']
    unless user_signed_in?
      @user = User.find_for_github_oauth(auth, request.env['affiliate.tag'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication # This will throw if @user is not activated
      end
    else
      # Right now, if you are going through the oAuth flow while logged in, you are connecting your GitHub account.
      user_account = GithubUserAccount.where(account_id: auth.uid).first
      if user_account.nil?
        User.create_github_account!(current_user, auth)
      end

      redirect_to edit_user_programmer_path(current_user)
    end
  end

  def failure
    flash[:alert] = 'Unfortunately, there has been a problem with GitHub login.'
    redirect_to root_path
  end
end
