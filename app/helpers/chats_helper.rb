module ChatsHelper

  def chat_interlocutor(chat)
    current_user == chat.recipient ? chat.sender : chat.recipient
  end

end
