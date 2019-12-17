class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer    :parent_id
      t.string     :parent_type
      t.belongs_to :company
      t.string     :img_uid
      t.datetime   :delete_at
      t.timestamps null: false
    end
  end
end
