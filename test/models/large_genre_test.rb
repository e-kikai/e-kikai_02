# == Schema Information
#
# Table name: large_genres
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  order_no       :integer
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  machinelife_id :integer
#

require 'test_helper'

class LargeGenreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
