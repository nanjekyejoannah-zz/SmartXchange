# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  body         :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sender_id    :integer          not null
#  chat_room_id :integer          not null
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
