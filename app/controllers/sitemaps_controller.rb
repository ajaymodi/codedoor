class SitemapsController < ApplicationController

  def show
    # Redirect to CloudFront and S3
    redirect_to "https://d3pezy5dughvjp.cloudfront.net/sitemaps/sitemap1.xml.gz"
  end

end
