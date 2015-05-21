# == Schema Information
#
# Table name: genres
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  capacity_label  :string
#  capacity_unit   :string
#  order_no        :integer
#  middle_genre_id :integer          not null
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  machinelife_id  :integer
#

require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
