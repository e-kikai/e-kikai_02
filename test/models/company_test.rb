# == Schema Information
#
# Table name: companies
#
#  id             :integer          not null, primary key
#  name           :string
#  company_kana   :string
#  representative :string
#  officer        :string
#  tel            :string
#  fax            :string
#  mail           :string
#  zip            :string
#  addr1          :string
#  addr2          :string
#  addr3          :string
#  contact_tel    :string
#  contact_fax    :string
#  contact_mail   :string
#  website        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  deleted_at     :datetime
#  machinelife_id :integer
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
