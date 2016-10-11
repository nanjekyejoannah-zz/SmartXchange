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

class Message < ApplicationRecord
  validates_presence_of :chat_room_id, :sender_id, :body
  validates :body, length: {minimum: 1, maximum: 500}

  belongs_to :sender, class_name: 'User'
  belongs_to :chat_room, touch: true

  # maybe refactor / take out not necessary since default is asc
  default_scope -> { order(created_at: :asc) }

  # after_create_commit { MessageBroadcastJob.perform_later(self) }

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end

end
