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

class Image < ActiveRecord::Base
  dragonfly_accessor :img
  belongs_to :parent, :polymorphic => true

  validates :img, presence: true
end
