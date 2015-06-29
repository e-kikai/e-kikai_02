class UpdateCompaniesChangeSubdomain < ActiveRecord::Migration
  def change
    change_column :companies, :subdomain, :string
  end
end
