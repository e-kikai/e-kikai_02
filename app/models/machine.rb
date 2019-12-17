class Machine < ActiveRecord::Base

  # self.primary_key = "machine_id"

  ### 2 newsystems DB ###
  default_scope { where(company_id: Company::MACHINELIFE_IDS.values, deleted_at: nil) }

  # serialize :imgs

  belongs_to :company
  belongs_to :genre
  # belongs_to :image
  has_one    :middle_genre, through: :genre,        foreign_key: :large_genre_id
  has_one    :large_genre,  through: :middle_genre, foreign_key: :xl_genre_id
  # has_many   :images, :as => :parent
  has_many   :contacts

  enum commissions: {不可:'0' ,可:'1'}

  validates :name,       presence: true
  validates :genre_id,   presence: true
  validates :company_id, presence: true

  def commission_enum
    Machine.commissions
  end

  def self.search_list(q)
    includes(:company).search(q).result.order("machines.name, machines.created_at DESC")
  end

  def self.search_names(q)
    search(q).result.select(:name).uniq.order(:name).pluck(:name)
  end

  def machinelife_images
    temp = JSON.parse(imgs.presence || "[]").to_a
    temp.unshift top_img if top_img.present?

    temp
  end
end
