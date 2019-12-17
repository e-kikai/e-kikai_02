class Genre < MachinelifeDb
  ### 2 newsystems DB ###
  alias_attribute :name,           :genre
  alias_attribute :middle_genre_id, :large_genre_id


  belongs_to :middle_genre,                    foreign_key: :large_genre_id
  delegate   :large_genre,  to: :middle_genre, foreign_key: :xl_genre_id
  has_many   :machines

  validates :name, presence: true
end
