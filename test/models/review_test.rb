# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  reviewer_id     :integer          not null
#  reviewable_type :string           not null
#  reviewable_id   :integer          not null
#  chat_room_id    :integer          not null
#  language        :string           not null
#  language_level  :integer          not null
#  comment         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
