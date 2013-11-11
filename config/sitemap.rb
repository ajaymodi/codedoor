# SitemapGenerator integration with Heroku, from http://www.jademind.com/blog/posts/updating-sitemap-file-on-heroku

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.codedoor.com"

# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'

# store on S3 using Fog
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new

# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"

# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  @programmer_search = ProgrammerSearch.new({}, false)
  @programmer_search.programmers.each do |programmer|
    add programmer_path(programmer)
  end
  num_pages = (@programmer_search.programmers.count.to_f / 10).ceil
  for i in 1..num_pages do
    if i == 1
      add programmers_path
    else
      add programmers_path(page: i)
    end
  end

  Skill.all.each do |skill|
    @programmer_search = ProgrammerSearch.new({skill_name: skill.name}, false)
    num_pages = (@programmer_search.programmers.count.to_f / 10).ceil
    for i in 1..num_pages do
      add programmers_path(skill_name: skill.name, page: i)
    end
  end

end

SitemapGenerator::Sitemap.ping_search_engines
