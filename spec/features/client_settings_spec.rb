require 'spec_helper'

feature 'Client settings', js: true do
  scenario 'client sign up and editing' do
    client_sign_up

    # Saving your client for the first time should bring you to the search page.
    page.should have_content('No programmers have matched your search.')

    click_link 'Settings'
    click_link 'Client Info'

    find('#client_company').value.should eq('Test Company')
    find('#client_description').value.should eq('Test Description')

    fill_in 'Description', with: 'New Description'
    click_button 'Save'

    find('#client_description').value.should eq('New Description')
  end
end
