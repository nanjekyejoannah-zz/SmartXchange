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
#

class EmailSubscription < ApplicationRecord
  validates_presence_of :user_id
  validates :user_id, uniqueness: true

  belongs_to :user
end
