# == Schema Information
#
# Table name: middle_genres
#
#  id             :integer          not null, primary key
#  name           :string           not null
#  order_no       :integer
#  large_genre_id :integer
#  deleted_at     :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  machinelife_id :integer
#

require 'test_helper'

class MiddleGenreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
