require 'spec_helper'

feature 'Blog', js: true do
  scenario 'getting affiliate user added' do
    visit '/blog'
    page.should have_content('Open Source and Hiring')
    page.should have_content('Learning About Cool Open Source Projects')

    visit '/blog/learning_about_cool_open_source_projects'
    page.should_not have_content('Open Source and Hiring')
    page.should have_content('Learning About Cool Open Source Projects')
    page.should have_content('Back to index')

    # If the blog post does not exist, it should redirect
    visit '/blog/blog_post_that_does_not_exist'
    page.should have_content('Open Source and Hiring')
    page.should have_content('Learning About Cool Open Source Projects')
    page.should_not have_content('Back to index')
  end
end
