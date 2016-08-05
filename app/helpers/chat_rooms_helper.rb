module ChatRoomsHelper

  def chat_room_interlocutor(chat_room, user)
    user == chat_room.recipient ? chat_room.initiator : chat_room.recipient
  end

  #false in quotations works on heroku but not local server
  def chat_room_count_unread(chat_room, user)
    chat_room.notifications.where(read: false, notified_id: user.id).count
  end

  # Ensures only 1 notification is created per new message(s) created
  def chat_room_notification_check(chat_room, receiver)
    if chat_room.notifications.where(read: false, notified_id: receiver.id).count > 0
      return false
    end
    true
  end

  def chat_room_mark_read(chat_room_id, notified_id)
    # assuming only one notification is created per new message(s) in chat room, by above method
    Notification.where(chat_room_id: chat_room_id, notified_id: notified_id, read: false).update(read: true)
  end

end
