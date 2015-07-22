class AddCompaniesSites < ActiveRecord::Migration
  def change
    add_column :companies, :sites, :text
  end
end
