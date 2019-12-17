class ChangeSomeColumn2 < ActiveRecord::Migration
  def change
    rename_column :genres, :capacity_kana, :capacity_label
    change_column :contacts, :content, :text, :null => false
  end
end
