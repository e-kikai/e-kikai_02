class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :genre
      t.string :genre_kana
      t.string :capacity_kana
      t.string :capacity_unit
      t.integer :order_no
      t.belongs_to :middle_genre

      t.datetime :deleted_at
      
      t.timestamps null: false
    end
  end
end
