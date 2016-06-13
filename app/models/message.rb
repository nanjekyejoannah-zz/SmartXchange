# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  body       :text
#  chat_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
  belongs_to :chat
  belongs_to :user #change to sender eventually
  default_scope -> { order(created_at: :asc) } #may take this out

  validates_presence_of :body, :chat_id, :user_id
end
