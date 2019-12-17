class UpdateCompaniesAddSubdomainAndMachinelifeImages < ActiveRecord::Migration
  def change
    add_column :companies, :subdomain, :text
    add_column :companies, :machinelife_images, :text
  end
end
