# == Schema Information
#
# Table name: notifications
#
#  id           :integer          not null, primary key
#  read         :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notified_id  :integer
#  notifier_id  :integer
#  message_id   :integer
#  chat_room_id :integer
#

class Notification < ApplicationRecord
  belongs_to :notified, class_name: 'User'
  belongs_to :notifier, class_name: 'User'
  belongs_to :chat_room
  belongs_to :message

  validates_presence_of :notified_id, :notifier_id, :chat_room_id, :message_id
end
