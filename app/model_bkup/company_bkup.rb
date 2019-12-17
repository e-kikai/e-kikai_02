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
  # include Hashie::Mash

  serialize :machinelife_images, Array
  serialize :infos
  serialize :offices, Array
  store :sites, accessors: [:theme_color, :headcopy, :top_img_title, :top_img_content, :top_summary_title, :top_summary_content, :company_title, :company_content, :makers, :histories, :site_top_img_uid]

  # dragonfly_accessor :site_top_img

  has_many :machines
  has_many :users
  has_many :images, :as => :parent
  has_many :contacts
  has_many :company_users

  accepts_nested_attributes_for :images

  validates :name, presence: true

  THEME_COLORS = {
    red:  '#c22', orange: '#fb2',    yellow: '#cc2', yellowgreen: '#9c6',
    lime: '#2c2', green:  '#007042', sky:    '#2cc', cyan:        '#009CD1',
    blue: '#22c', purple: '#92c',    moa:    '#c2c', pink:        '#cbb'
  }

  def name_strip_kabu
    name.gsub(/(株式|有限|合.)会社/, '')
  end

  def zip_shaping
    /^([0-9]{3}).*([0-9]{4})$/ =~ zip ? "#{$1}-#{$2}" : zip
  end

  def self.crawl
    where.not(machinelife_id: nil).each do |c|
      # マシンライフからJSONデータを取得
      json  = open("http://www.zenkiren.net/system/ajax/e-kikai_crawled_get.php?t=companies&c=#{c.machinelife_id}").read
      data  = ActiveSupport::JSON.decode json rescue raise json
      raise "マシンライフからデータを取得できませんでした" unless data.include?("id")

      # 画像配列整形
      imgs = (data["imgs"].kind_of? Hash) ? data["imgs"].values : Array(data["imgs"])
      imgs.unshift(data["top_img"]).reject!(&:blank?)

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
        infos:          data["infos"].to_h,
        offices:        data["offices"],
        machinelife_images: imgs,
      })

      # imgs.each do |i|
      #   if image = c.images.find_by(img_name: i)
      #     content_length = open("https://s3-ap-northeast-1.amazonaws.com/machinelife/machine/public/media/company/#{i}").meta["content-length"].to_i
      #     break if content_length == image.img.size
      #   else
      #     image = c.images.build
      #   end
      #
      #   image.img_url = "https://s3-ap-northeast-1.amazonaws.com/machinelife/machine/public/media/company/#{i}"
      #   image.save
      # end
    end
  end
end
