class BlogController < ApplicationController
  def index
    @custom_title = 'Blog'
  end

  def show
    @blog_name = params[:id]
    unless BLOG_TITLES[@blog_name] && lookup_context.exists?(@blog_name, ['blog'], true)
      redirect_to action: :index
    end
    @custom_title = BLOG_TITLES[@blog_name]
  end

  BLOG_TITLES =
  {'open_source_and_hiring' => 'Open Source And Hiring',
   'learning_about_cool_open_source_projects' => 'Learning About Cool Open Source Projects',
   'y_combinator_hired_com' => 'Why Doesn\'t Y Combinator Have Its Own Hired.com?'}
end
