# == Schema Information
#
# Table name: large_genres
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  order_no       :integer
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  machinelife_id :integer
#

class LargeGenre < ActiveRecord::Base
  require 'open-uri'

  has_many :middle_genres
  has_many :genres,   :through => :middle_genres
  has_many :machines, :through => :genres

  validates :name, presence: true

  def self.crawl
    # マシンライフからJSONデータを取得
    json  = open("http://www.zenkiren.net/system/ajax/e-kikai_crawled_get.php?t=large_genres").read
    datas = ActiveSupport::JSON.decode json rescue raise json
    raise "マシンライフからデータを取得できませんでした" if !datas[0].include?("id")

    # データの整形
    datas.each do |d|
      find_or_create_by(:machinelife_id => d["id"]).update({
        name:     d["xl_genre"],
        order_no: d["order_no"],
      })
    end
  end
end
