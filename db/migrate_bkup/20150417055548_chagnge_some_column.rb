class ChagngeSomeColumn < ActiveRecord::Migration
  def change
    rename_column :contacts, :company, :name
    change_column :contacts, :name,    :string, :null => false
    change_column :contacts, :mail,    :string, :null => false
    change_column :contacts, :content, :string, :null => false

    change_column :machines, :name,       :string,  :null => false
    change_column :machines, :genre_id,   :integer, :null => false
    change_column :machines, :company_id, :integer, :null => false

    rename_column :genres, :genre, :name
    remove_column :genres, :genre_kana
    add_index     :genres, :middle_genre_id
    change_column :genres, :name,            :string,  :null => false
    change_column :genres, :middle_genre_id, :integer, :null => false

    rename_column :middle_genres, :middle_genre, :name
    remove_column :middle_genres, :middle_genre_kana
    add_index     :middle_genres, :large_genre_id
    change_column :middle_genres, :name,           :string,  :null => false
    # change_column :middle_genres, :large_genre_id, :integer, :null => false

    rename_column :large_genres, :large_genre, :name
    remove_column :large_genres, :large_genre_kana
    change_column :large_genres, :name, :string, :null => false

    rename_column :companies, :company, :name
  end
end
