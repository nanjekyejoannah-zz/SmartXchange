module MessagesHelper

  def self_or_other(message)
    message.sender == current_user ? "self" : "other"
  end

  def message_interlocutor(message)
    message.sender == message.chat.sender ? message.chat.sender : message.chat.recipient
  end

end
