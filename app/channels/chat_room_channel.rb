# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatRoomChannel < ApplicationCable::Channel
  include ChatRoomsHelper

  def subscribed
    stream_from "chat_rooms_#{params['chat_room_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    message = current_user.sent_messages.create!(body: data['message'], chat_room_id: data['chat_room_id'])
    # need to refactor and implement error message here
    if message
      ActionCable.server.broadcast "chat_rooms_#{message.chat_room.id}_channel",
                                   message: render_message(message)
    end
  end

  def update_notification(data)
    chat_room_mark_read(data['chat_room_id'], data['notified_id'])
  end

  private

  def render_message(message)
    MessagesController.render(partial: 'messages/message',
                              locals: { message: message, current_user: current_user})
  end

end
