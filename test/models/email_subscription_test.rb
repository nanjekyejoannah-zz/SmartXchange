# == Schema Information
#
# Table name: email_subscriptions
#
#  id                   :integer          not null, primary key
#  user_id              :integer          not null
#  weekly_notifications :boolean          default(TRUE), not null
#  monthly_update       :boolean          default(TRUE), not null
#  language_matches     :boolean          default(TRUE), not null
#  notify_match         :boolean          default(TRUE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  new_conversation     :boolean          default(TRUE), not null
#  new_message          :boolean          default(TRUE), not null
#

require 'test_helper'

class EmailSubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
