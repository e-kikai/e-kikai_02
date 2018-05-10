# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.e-kikai.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add "/sitemap", :priority => 0.5, :changefreq => 'weekly'
  add "/about",   :priority => 0.3, :changefreq => 'monthly'

  LargeGenre.select(:id).each do |l|
    add "/large_genre/#{l.id}", :priority => 0.4, :changefreq => 'monthly'
  end

  MiddleGenre.select(:id).each do |m|
    add "/search?middle_genre_id_eq=#{m.id}", :priority => 0.7, :changefreq => 'daily'
  end

  Genre.select(:id).each do |g|
    add "/search?genre_id_eq=#{g.id}", :priority => 0.7, :changefreq => 'daily'
  end

  Machine.group(:maker).order(:maker).pluck(:maker).each do |maker|
    add "/search?maker_eq=#{maker}", :priority => 0.7, :changefreq => 'daily' if maker.present?
  end

  # Machine.joins(:genre).group(:genre_id, "genres.name", :maker).having("count(*) > 1").count.keys.each do |gm|
  #   add "/search?genre_id_eq=#{gm[0]}&maker_eq=#{gm[2]}", :priority => 0.8, :changefreq => 'daily' if gm[2].present?
  # end

  # e-kikai Network
  Company.select(:id, :subdomain).each do |c|
    add "/#{c.subdomain}/", :priority => 0.8, :changefreq => 'daily'
    add "/search?company_id_eq=#{c.id}", :priority => 0.7, :changefreq => 'daily'
  end

  # 機械詳細
  Machine.select(:id, :updated_at).each do |m|
    add "/machine/#{m.id}", :priority => 0.6, :changefreq => 'daily', :lastmod => m.updated_at
    add "/detail/#{m.id}",  :priority => 0.6, :changefreq => 'daily', :lastmod => m.updated_at
  end
end
