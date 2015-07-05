class ChangeCompanyUsersAddCompanyId < ActiveRecord::Migration
  def change
    add_column :company_users, :company_id, :integer

    add_column :companies, :infos,   :text
    add_column :companies, :offices, :text
  end
end
