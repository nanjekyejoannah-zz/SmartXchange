module ChatRoomsHelper

  def chat_room_interlocutor(chat_room, user)
    user == chat_room.recipient ? chat_room.initiator : chat_room.recipient
  end

  # assumes that chat_room is loaded with notifications and we don't have to query the database again
  def chat_room_count_unread(chat_room, user)
    chat_room.notifications.select{|notification| notification.read == false && notification.notified_id == user.id}.count
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

  def chat_room_convert_title_to_img(title)
    if title == "Spanish"
      image_tag('spain-flag-circular.png', alt: 'Spanish')
    elsif title == "Italian"
      image_tag('italy-flag-circular.png', alt: 'Italian')
    elsif title == "German"
      image_tag('germany-flag-circular.png', alt: 'German')
    elsif title == "English"
      image_tag('united-kingdom-flag-circular.png', alt: 'English')
    elsif title == "French"
      image_tag('france-flag-circular.png', alt: 'French')
    end
  end

end
