# == Schema Information
#
# Table name: follows
#
#  id              :integer          not null, primary key
#  follower_id     :integer          not null
#  followable_type :string           not null
#  followable_id   :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
