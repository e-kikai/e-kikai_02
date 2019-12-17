class ChangeSomeColumn3 < ActiveRecord::Migration
  def change
    remove_column :images, :company_id
  end
end
