module Crawler
  extend ActiveSupport::Concern

  require 'open-uri'

  included do
    MACHINELIFE_URI = "http://www.zenkiren.net"
    CRAWL_URI       = "#{MACHINELIFE_URI}/system/ajax/e-kikai_crawled_get.php"
    MEDIA_URI       = "#{MACHINELIFE_URI}/media"
    COMPANY_IMG_URL = "#{MEDIA_URI}/company"
    MACHINE_IMG_URL = "#{MEDIA_URI}/machine"

    # マシンライフからJSONデータを取得
    def self.get_datas(query)
      json  = open("#{CRAWL_URI}?#{query}").read
      datas = ActiveSupport::JSON.decode json rescue raise json

      raise "マシンライフからデータを取得できませんでした" if datas.blank? || !datas[0].include?("id")

      datas
    rescue => e
      puts e.message
      {}
    end
  end
end
