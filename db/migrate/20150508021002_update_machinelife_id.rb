class UpdateMachinelifeId < ActiveRecord::Migration
  def change
    add_column :large_genres,  :machinelife_id, :integer
    add_column :middle_genres, :machinelife_id, :integer
    add_column :genres,        :machinelife_id, :integer
    add_column :machines,      :machinelife_id, :integer
    add_column :companies,     :machinelife_id, :integer
  end
end
