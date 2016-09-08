# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  sender_id    :integer
#  chat_room_id :integer
#

class Message < ApplicationRecord
  validates_presence_of :chat_room_id, :sender_id, :body
  validates :body, length: {minimum: 1, maximum: 500}

  belongs_to :sender, class_name: 'User'
  belongs_to :chat_room, touch: true

  default_scope -> { order(created_at: :asc) } 

  # after_create_commit { MessageBroadcastJob.perform_later(self) }

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end

end
