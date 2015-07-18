class CrawlJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later
    Company.crawl

    # target = args
    # puts target
    # puts "aaaaa"
    # Company.crawl
    # case target
    # when "machine";      Machine.crawl
    # when "ota";          Machine.crawl_ota
    # when "company";      Company.crawl
    # when "large_genre";  LargeGenre.crawl
    # when "middle_genre"; MiddleGenre.crawl
    # when "genre";        Genre.crawl
    # else
    #   puts "aaaaa"
    #   Company.crawl
    # end
  end
end
