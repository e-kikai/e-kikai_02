class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company
      t.string :company_kana
      t.string :representative
      t.string :officer
      t.string :tel
      t.string :fax
      t.string :mail
      t.string :zip
      t.string :addr1
      t.string :addr2
      t.string :addr3
      t.string :contact_tel
      t.string :contact_fax
      t.string :contact_mail
      t.string :website

      t.timestamps null: false

      t.datetime :deleted_at
    end
  end
end
