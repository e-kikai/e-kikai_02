class CreateMiddleGenres < ActiveRecord::Migration
  def change
    create_table :middle_genres do |t|
      t.string :middle_genre
      t.string :middle_genre_kana
      t.integer :order_no
      t.belongs_to :large_genre

      t.datetime :deleted_at

      t.timestamps null: false

    end
  end
end
