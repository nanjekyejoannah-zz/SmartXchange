# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
# For uri encoding, URI:encode is deprecated according to stackoverflow question 6714196
require 'cgi'
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

    # for chatbot response, assuming chat bot is always recipient, and chat bot id = 2,
    chat_room = ChatRoom.find_by(id: data['chat_room_id'])
    if chat_room.recipient.id == 2
      p "chat bot response"
      response = Pandorabots::API.talk(1409612860083, "uktrivia", CGI.escape(message.body), "chatroom#{chat_room.id}", user_key: "22838106ec021d169fa3cc0bc7f8983a")
      # responds even if error (error is produced in output), may refactor later, and see if its faster to do Message.create!
      response_message = chat_room.recipient.sent_messages.create!(body: response["responses"][0], chat_room_id: chat_room.id)
      # maybe implement code for if there is an error in message creation here, like above
      if response_message
        ActionCable.server.broadcast "chat_rooms_#{chat_room.id}_channel",
                                     message: render_message(response_message)
      end
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
