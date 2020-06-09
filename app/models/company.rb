class Company < ActiveRecord::Base
  ### 2 newsystems DB ###
  # MACHINELIFE_IDS = {
  #   "horikawakikai"   => 1,
  #   "kusumotokikai"   => 2,
  #   "kataekikai"      => 3,
  #   "henmiseiki"      => 4,
  #   "okabekikai"      => 5,
  #   "sanwaseiki"      => 6,
  #   "kobayashikikai"  => 9,
  #   "sanwa_kitakanto" => 62,
  #   # "otakikai"        => 235,
  #   "deguchikikai"    => 258,
  #   "ishino"          => 301,
  #   "senbakikai"      => 318,
  #   "daihoukikai"     => 320,
  #   "nakafujikikai"   => 324,
  #   "okabe_okayama"   => 343,
  #   "sanwa_fukuyama"  => 348,
  #   "ibuki_kanto"     => 382,
  #   "ibuki_thai"      => 407,
  #   "okabe_kanto"     => 416,
  # }

  # self.primary_key = "company_id"

  # default_scope { where(id: Company::MACHINELIFE_IDS.values, deleted_at: nil) }
  default_scope { where(deleted_at: nil).where.not(ekikai_subdomain: nil) }

  alias_attribute :name, :company

  serialize :infos
  # store :deleted_at, accessors: [:theme_color, :headcopy, :top_img_title, :top_img_content, :top_summary_title, :top_summary_content, :company_title, :company_content, :makers, :histories, :site_top_img_uid]

  has_many :machines
  # has_many :users
  # has_many :images, :as => :parent
  has_many :contacts
  # has_many :company_users

  has_one :companysite

  # accepts_nested_attributes_for :images

  validates :name, presence: true

  THEME_COLORS = {
    red:  '#c22', orange: '#fb2',    yellow: '#cc2', yellowgreen: '#9c6',
    lime: '#2c2', green:  '#007042', sky:    '#2cc', cyan:        '#009CD1',
    blue: '#22c', purple: '#92c',    moa:    '#c2c', pink:        '#cbb'
  }

  def name_strip_kabu
    company.gsub(/(株式|有限|合.)会社/, '')
  end

  def zip_shaping
    /^([0-9]{3}).*([0-9]{4})$/ =~ zip ? "#{$1}-#{$2}" : zip
  end

  def subdomain
    # (MACHINELIFE_IDS.find { |k,v| v == self.id })[0]
    ekikai_subdomain
  end

  # def self.subdomain2id(subdomain)
  #   MACHINELIFE_IDS[subdomain]
  # end

  def machinelife_images
    temp = JSON.parse(imgs.presence || "[]").to_a
    temp.unshift top_img if top_img.present?

    temp
  end

  def offices
    JSON.parse(self[:offices].presence || "{}")
  end

  def infos
    JSON.parse(self[:infos].presence || "{}")
  end

  def view_website
    if self.website.blank?
      "https://#{self.subdomain}.e-kikai.com/"
    elsif self.website =~ /e-kikai/
      "https://#{self.subdomain}.e-kikai.com/"
    else
      self.website
    end
  end
end
