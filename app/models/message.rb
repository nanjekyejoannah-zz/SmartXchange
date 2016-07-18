# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  body         :text
#  chat_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sender_id    :integer
#  chat_room_id :integer
#

class Message < ApplicationRecord
  include ChatRoomsHelper
  # belongs_to :chat
  belongs_to :sender, class_name: 'User'
  belongs_to :chat_room
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :asc) } #may take this out

  validates_presence_of :chat_room_id, :sender_id
  validates :body, presence: true, length: {minimum: 2, maximum: 1000}

  # after_create_commit { MessageBroadcastJob.perform_later(self) }
  after_create_commit { create_notification }

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end

  private

  def create_notification
    if chat_room_check(self.chat_room, chat_room_interlocutor(self.chat_room, self.sender))
      Notification.create!(
        notified_id: chat_room_interlocutor(self.chat_room, self.sender).id,
        notifier_id: self.sender.id,
        chat_room_id: self.chat_room.id,
        message_id: self.id
      )
    end
  end

end
