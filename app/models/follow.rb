# == Schema Information
#
# Table name: follows
#
#  id              :integer          not null, primary key
#  follower_id     :integer          not null
#  followable_type :string
#  followable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Follow < ApplicationRecord
  validates_presence_of :follower_id, :followable
  before_save :ensure_post_owner_not_follower

  belongs_to :followable, polymorphic: true, touch: true
  belongs_to :follower, class_name: 'User'
  # to make notification checks easier
  belongs_to :owner, :foreign_key => :follower_id, class_name: 'User'

  private

  def ensure_post_owner_not_follower
    raise "Post owner can not be follower!" if self.followable_type == 'Post' && self.followable.owner == self.follower
  end

end
