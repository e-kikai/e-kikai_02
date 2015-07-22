class CrawlJob < ActiveJob::Base
  queue_as :default

  def perform(target)
    # Do something later

    case target
    when "machine";      Machine.crawl
    when "ota";          Machine.crawl_ota
    when "company";      Company.crawl
    when "large_genre";  LargeGenre.crawl
    when "middle_genre"; MiddleGenre.crawl
    when "genre";        Genre.crawl
    else
      Rails.logger.info "ターゲット不明 : #{target}"
    end
  end
end
