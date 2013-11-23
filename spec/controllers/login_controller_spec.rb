require 'spec_helper'

describe LoginController do
  describe 'GET main' do
    it 'should render if user not signed in' do
      get :main
      response.should render_template('main')
    end

    it 'should redirect if user is signed in' do
      user = FactoryGirl.create(:user)
      sign_in(user)
      get :main
      response.should redirect_to(root_path)
    end
  end
end
