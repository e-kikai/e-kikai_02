class LargeGenre < ActiveRecord::Base
  ### 2 newsystems DB ###
  self.table_name  = 'xl_genres'
  alias_attribute :name, :xl_genre

  # default_scope { where(deleted_at: nil) }


  has_many :middle_genres, foreign_key: :xl_genre_id
  has_many :genres,        through: :middle_genres
  has_many :machines,      through: :genres

  validates :name, presence: true

  scope :list, -> { includes(:middle_genres, :genres) }
end
