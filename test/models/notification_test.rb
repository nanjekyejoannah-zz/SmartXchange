# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  read            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notified_id     :integer
#  notifier_id     :integer
#  notifiable_type :string
#  notifiable_id   :integer
#  sourceable_type :string
#  sourceable_id   :integer
#

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
