# == Schema Information
#
# Table name: middle_genres
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  order_no       :integer
#  large_genre_id :integer
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  machinelife_id :integer
#

class MiddleGenre < ActiveRecord::Base
  require 'open-uri'

  belongs_to :large_genre
  has_many   :genres
  has_many   :machines, :through => :genres

  validates :name, presence: true

  def self.crawl
    # マシンライフからJSONデータを取得
    json  = open("http://www.zenkiren.net/system/ajax/e-kikai_crawled_get.php?t=middle_genres").read
    datas = ActiveSupport::JSON.decode json rescue raise json
    raise "マシンライフからデータを取得できませんでした" if !datas[0].include?("id")

    # machinelife_ids = pluck(:machinelife_id)

    # データの整形
    datas.each do |d|
      next unless large_genre_id = LargeGenre.find_by(machinelife_id: d["xl_genre_id"]).id

      find_or_create_by(:machinelife_id => d["id"]).update({
        name:           d["large_genre"],
        order_no:       d["order_no"],
        large_genre_id: large_genre_id,
      })
      # machinelife_ids.delete(d["id"])
    end

    # 1件でも更新されていれば、削除
    # if machinelife_ids.present?
    #   where("machinelife_id IN (?)", machinelife_ids).delete_all
    # end
  end
end
