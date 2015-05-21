# == Schema Information
#
# Table name: companies
#
#  id             :integer          not null, primary key
#  name           :string
#  company_kana   :string
#  representative :string
#  officer        :string
#  tel            :string
#  fax            :string
#  mail           :string
#  zip            :string
#  addr1          :string
#  addr2          :string
#  addr3          :string
#  contact_tel    :string
#  contact_fax    :string
#  contact_mail   :string
#  website        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#  machinelife_id :integer
#

class Company < ActiveRecord::Base
  require 'open-uri'

  has_many :machines
  has_many :users

  has_many :images, :as => :parent
  has_many :contacts

  accepts_nested_attributes_for :images

  validates :name, presence: true

  def self.crawl
    where.not(machinelife_id: nil).each do |c|
      # マシンライフからJSONデータを取得
      json  = open("http://www.zenkiren.net/system/ajax/e-kikai_crawled_get.php?t=companies&c=#{c.machinelife_id}").read
      data  = ActiveSupport::JSON.decode json rescue raise json
      raise "マシンライフからデータを取得できませんでした" unless data.include?("id")

      # データの整形
      c.update({
        name:           data["company"],
        company_kana:   data["company_kana"],
        representative: data["representative"],
        officer:        data["officer"],
        tel:            data["tel"],
        fax:            data["fax"],
        mail:           data["mail"],
        zip:            data["zip"],
        contact_tel:    data["contact_tel"],
        contact_fax:    data["contact_fax"],
        contact_mail:   data["contact_mail"],
        addr1:          data["addr1"],
        addr2:          data["addr2"],
        addr3:          data["addr3"],
        website:        data["website"],
      })

      data["imgs"].unshift(data["top_img"]).reject!(&:blank?)

      data["imgs"].each do |i|
        if image = c.images.find_by(img_name: i)
          content_length = open("http://www.zenkiren.net/media/company/#{i}").meta["content-length"].to_i
          break if content_length == image.img.size
        else
          image = c.images.build
        end

        image.img_url = "http://www.zenkiren.net/media/company/#{i}"
        image.save
      end
    end
  end
end
