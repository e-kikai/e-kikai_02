# == Schema Information
#
# Table name: genres
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  capacity_label  :string
#  capacity_unit   :string
#  order_no        :integer
#  middle_genre_id :integer          not null
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  machinelife_id  :integer
#

class Genre < ActiveRecord::Base
  require 'open-uri'

  belongs_to :middle_genre
  delegate   :large_genre, to: :middle_genre
  has_many   :machines

  validates :name, presence: true

  def self.crawl
    # マシンライフからJSONデータを取得
    json  = open("http://www.zenkiren.net/system/ajax/e-kikai_crawled_get.php?t=genres").read
    datas = ActiveSupport::JSON.decode json rescue raise json
    raise "マシンライフからデータを取得できませんでした" if !datas[0].include?("id")

    # データの整形
    datas.each do |d|
      begin
        next unless middle_genre_id = MiddleGenre.find_by(machinelife_id: d["large_genre_id"]).id

        find_or_create_by(:machinelife_id => d["id"]).update({
          name:            d["genre"],
          capacity_label:  d["capacity_label"],
          capacity_unit:   d["capacity_unit"],
          order_no:        d["order_no"],
          middle_genre_id: middle_genre_id,
        })
      rescue => e
        puts e.message
        next
      end
    end
  end
end
