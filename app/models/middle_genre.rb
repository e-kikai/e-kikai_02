class MiddleGenre < ActiveRecord::Base
  ### 2 newsystems DB ###
  self.table_name  = 'large_genres'
  alias_attribute :name,           :large_genre
  alias_attribute :large_genre_id, :xl_genre_id

  belongs_to :large_genre, foreign_key: :xl_genre_id
  has_many   :genres,      foreign_key: :large_genre_id
  has_many   :machines,    through: :genres

  validates :name, presence: true

  def name
    self[:large_genre]
  end
end
