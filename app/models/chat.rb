# == Schema Information
#
# Table name: chats
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Chat < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'
  default_scope -> { order(created_at: :desc) }

  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, :scope => :recipient_id

  #to check for any existing chats initiated by you or with you
  scope :involving, -> (user) do
    where("chats.sender_id =? OR chats.recipient_id =?",user.id,user.id)
  end

  #to check to see if there any existing chats between you and the potential recepient
  scope :between, -> (sender_id,recipient_id) do
    where("(chats.sender_id = ? AND chats.recipient_id =?) OR (chats.sender_id = ? AND chats.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end


end
