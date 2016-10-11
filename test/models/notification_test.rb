# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  read            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notified_id     :integer          not null
#  notifier_id     :integer          not null
#  notifiable_type :string           not null
#  notifiable_id   :integer          not null
#  sourceable_type :string           not null
#  sourceable_id   :integer          not null
#

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
