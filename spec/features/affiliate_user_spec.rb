require 'spec_helper'

feature 'Affiliate users', js: true do
  scenario 'getting affiliate user added' do
    affiliate = FactoryGirl.create(:user)
    visit "/?ref=#{affiliate.id}"
    visit '/'
    click_link 'Log in with GitHub'

    User.last.referred_user.should eq(affiliate)
  end
end
