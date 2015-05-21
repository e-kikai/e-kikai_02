# == Schema Information
#
# Table name: machines
#
#  id             :integer          not null, primary key
#  no             :string
#  name           :string           not null
#  maker          :string
#  model          :string
#  year           :string
#  capacity       :float
#  location       :string
#  addr1          :string
#  addr2          :string
#  addr3          :string
#  spec           :text
#  accessory      :text
#  comment        :text
#  commission     :integer
#  genre_id       :integer          not null
#  company_id     :integer          not null
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  machinelife_id :integer
#

require 'test_helper'

class MachineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
