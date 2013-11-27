class BlogController < ApplicationController
  def index
    @custom_title = 'Blog'
    @custom_description = 'CodeDoor\'s blog, featuring articles and discussion about freelance software programming, open source software development, and recruiting.'
  end

  def show
    @blog_name = params[:id]
    unless BLOG_TITLES[@blog_name] && lookup_context.exists?(@blog_name, ['blog'], true)
      redirect_to action: :index
    else
      @custom_title = BLOG_TITLES[@blog_name].first
      @custom_description = BLOG_TITLES[@blog_name].last
    end
  end

  BLOG_TITLES =
  {'open_source_and_hiring' => ['Open Source And Hiring', 'One night, I was reading the “Who’s Hiring Freelance” thread on Hacker News, when I decided that there had to be a more efficient way to match programmers with freelance jobs. While we have sites like oDesk and eLance, they seem to be have more of an emphasis on price than quality.'],
   'learning_about_cool_open_source_projects' => ['Learning About Cool Open Source Projects', 'Bullet is a ruby gem that detects if your Rails site is making inefficient queries.  I decided to use it, and discovered a couple of n+1 queries where 1 query would do.'],
   'y_combinator_hired_com' => ['Why Doesn\'t Y Combinator Have Its Own Hired.com?', 'Right now, companies complain that they find it difficult to hire on-site full-time programmers.  The demand for full-time programmers far exceeds the supply.  If I wanted a software development job, I would simply pick the organizations that I were interested in, and apply through their website.'],
   'penny_arcade_fun_job_fun_life' => ['Do Penny Arcade Fans Want A Fun Job Or Fun Life?', 'Penny Arcade, a popular web comic about video games, is hiring a software developer and IT administrator. The listing says that the wage is below market, and that work-life balance is not very good.  This has attracted criticism from the likes of Marco Arment and Christopher Buecheler.']}
end
