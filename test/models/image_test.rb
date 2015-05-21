# == Schema Information
#
# Table name: images
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  parent_type :string
#  img_uid     :string
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
