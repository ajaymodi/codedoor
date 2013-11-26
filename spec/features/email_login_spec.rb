require 'spec_helper'

feature 'Email login', js: true do
  scenario 'registering with e-mail account' do
    # Sign up with email account, and then go to programmers page, and then log in with github
    visit '/'
    click_link 'Or sign up via email (for clients)'

    check('user_checked_terms')
    select('United States', from: 'user_country')
    select('California', from: 'user_state')
    fill_in 'City', with: 'Burlingame'

    fill_in 'Full name', with: 'Mr. Client'
    fill_in 'Email', with: 'test@example.com'

    fill_in 'Password', with: 'testtest'
    find('#user_password_confirmation').set('testtest')
    click_button('Create Client Account')

    page.should have_content 'Client Info'
    fill_in 'Company', with: 'Test Company'
    fill_in 'Description', with: 'Test Description'
    click_button 'Save'

    page.should have_content 'Your client account has been created.'

    click_link 'Settings'
    click_link 'Create Programmer Account'
    page.should have_content 'To sign up as a programmer, you need to log in with your GitHub Account.'

    GithubUserAccount.any_instance.stub(:load_repos).and_return([])

    find('#large-github-button').click
    page.should have_content 'Contractors on CodeDoor need at least one open-source contribution to a GitHub repository with at least 25 stars, or another popular repository elsewhere.'
  end
end
