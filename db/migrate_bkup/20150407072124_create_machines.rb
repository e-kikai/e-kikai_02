class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :no
      t.string :name
      t.string :maker
      t.string :model
      t.string :year
      t.float :capacity
      t.string :location
      t.string :addr1
      t.string :addr2
      t.string :addr3
      t.text :spec
      t.text :accessory
      t.text :comment
      t.integer :commission

      t.references :genre
      t.references :company
      t.datetime :deleted_at

      t.timestamps null: false

    end

    add_index :machines, :genre_id
    add_index :machines, :company_id
    add_index :machines, :created_at
    add_index :machines, :deleted_at
    add_index :machines, :addr1
  end
end
