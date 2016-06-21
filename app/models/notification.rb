# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  chat_id     :integer
#  read        :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  notified_id :integer
#  notifier_id :integer
#  message_id  :integer
#

class Notification < ActiveRecord::Base
  belongs_to :notified, class_name: 'User'
  belongs_to :notifier, class_name: 'User'
  belongs_to :chat

  validates :notified_id, :notifier_id, :chat_id, :message_id, presence: true
end
