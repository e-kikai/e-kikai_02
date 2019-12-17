class AddMachineMakerKana < ActiveRecord::Migration
  def change
    add_column :machines, :maker_kana, :string
  end
end
