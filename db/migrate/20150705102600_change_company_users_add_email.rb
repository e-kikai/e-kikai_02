class ChangeCompanyUsersAddEmail < ActiveRecord::Migration
  def change
    add_column :company_users, :email, :string, null: false, default: ""
  end
end
