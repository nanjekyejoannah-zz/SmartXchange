# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  value        :integer          not null
#  votable_type :string           not null
#  votable_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :integer
#

require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
