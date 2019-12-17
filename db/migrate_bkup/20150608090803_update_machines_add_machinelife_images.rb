class UpdateMachinesAddMachinelifeImages < ActiveRecord::Migration
  def change
    add_column :machines, :machinelife_images, :text
  end
end
