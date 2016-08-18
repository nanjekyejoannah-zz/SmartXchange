# == Schema Information
#
# Table name: chat_rooms
#
#  id           :integer          not null, primary key
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  initiator_id :integer
#  recipient_id :integer
#

class ChatRoom < ApplicationRecord
  belongs_to :initiator, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy

  default_scope -> { order(created_at: :desc) } #may take this out

  #to check for any existing chats initiated by you or with you
  scope :involving, -> (user) do
    where("chat_rooms.initiator_id =? OR chat_rooms.recipient_id =?",user.id,user.id)
  end

  #to check to see if there any existing chats between you and the potential recepient
  scope :between, -> (initiator,recipient_id) do
    where("((chat_rooms.initiator_id = ? AND chat_rooms.recipient_id =?) OR (chat_rooms.initiator_id = ? AND chat_rooms.recipient_id =?)) AND chat_rooms.title = ?", initiator.id,recipient_id, recipient_id, initiator.id,initiator.language)
  end


end
