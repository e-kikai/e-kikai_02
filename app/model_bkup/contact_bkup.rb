# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  officer    :string
#  mail       :string           not null
#  tel        :string
#  content    :text             not null
#  company_id :integer
#  machine_id :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
  belongs_to :machine
  belongs_to :company

  validates :name, presence: true
  validates :mail, presence: true
  validates :content, presence: true
end
