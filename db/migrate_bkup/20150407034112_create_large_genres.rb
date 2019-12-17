class CreateLargeGenres < ActiveRecord::Migration
  def change
    create_table :large_genres do |t|
      t.string :large_genre
      t.string :large_genre_kana
      t.integer :order_no
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
