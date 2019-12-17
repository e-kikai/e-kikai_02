class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :company
      t.string :officer
      t.string :mail
      t.string :tel
      t.text :content
      t.references :company
      t.references :machine
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :contacts, :company_id
    add_index :contacts, :machine_id

    rename_column :images, :delete_at, :deleted_at
  end
end
