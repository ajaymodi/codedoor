class BlogController < ApplicationController
  def index
    @custom_title = 'Blog'
  end

  def show
    @custom_title = 'Blog'
    @blog_name = params[:id]
    unless lookup_context.exists?(@blog_name, ['blog'], true)
      redirect_to action: :index
    end
  end
end
