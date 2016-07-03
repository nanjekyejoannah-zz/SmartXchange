module ChatsHelper

  def chat_interlocutor(chat)
    current_user == chat.recipient ? chat.sender : chat.recipient
  end

  #false in quotations works on heroku but not local server
  def chat_count_unread(chat, user)
    chat.notifications.where(read: false, notified_id: user.id).count
  end

  def chat_mark_read(chat, user)
    chat.notifications.where(read: false, notified_id: user.id).each do |notification|
      notification.update(read: true)
    end
  end

end
