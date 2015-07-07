class AddIndexDeletedAts < ActiveRecord::Migration
  def change
    add_column :machines, :image_id, :integer
    add_column :companies, :image_id, :integer

    add_column :company_users, :deleted_at, :datetime

    add_index :companies, :deleted_at
    add_index :large_genres, :deleted_at
    add_index :middle_genres, :deleted_at
    add_index :genres, :deleted_at
    add_index :contacts, :deleted_at
    add_index :users, :deleted_at
    add_index :company_users, :deleted_at

    add_index :companies, :machinelife_id
    add_index :companies, :subdomain

    add_index :machines, :machinelife_id
  end
end
