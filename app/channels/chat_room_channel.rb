# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
# For uri encoding, URI:encode is deprecated according to stackoverflow question 6714196
require 'cgi'
class ChatRoomChannel < ApplicationCable::Channel
  include ChatRoomsHelper
  include UsersHelper

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
      broadcast_notification(message)
    end

    # for chatbot response, assuming chat bot is always recipient, and chat bot id = 6, refactor and maybe change check about current_user's message getting through
    chat_room = ChatRoom.find_by(id: data['chat_room_id'])
    # ensuring that there is a message and the message sender is not the chatbot
    if chat_room.recipient.id == 6 && message && message.sender_id != 6
      response = Pandorabots::API.talk(ENV['PANDORABOTS_APP_ID'], "uktrivia", CGI.escape(message.body), "chatroom#{chat_room.id}", user_key: ENV['PANDORABOTS_USER_KEY'])
      # responds even if error (error is produced in output), may refactor later, and see if its faster to do Message.create!
      response_message = chat_room.recipient.sent_messages.create!(body: response["responses"][0], chat_room_id: chat_room.id)
      # maybe implement code for if there is an error in message creation here, like above
      if response_message
        ActionCable.server.broadcast "chat_rooms_#{chat_room.id}_channel",
                                     message: render_message(response_message)
        broadcast_notification(response_message)
      end
    end

  end

  def broadcast_notification(message)
    # maybe refactor and implement a better method than this instance variable in the future
    @notification = nil
    # chat room notifications check
    if chat_room_notification_check(message.chat_room, chat_room_interlocutor(message.chat_room, message.sender))
      @notification = Notification.create!(
        notified_id: chat_room_interlocutor(message.chat_room, message.sender).id,
        notifier_id: message.sender.id,
        notifiable_type: 'ChatRoom',
        notifiable_id: message.chat_room.id,
        sourceable_type: 'Message',
        sourceable_id: message.id
      )
    end
    # using message.sender in code below because of potential conflict if chatbot is responding
    # broadcast to notifications channel
    if !@notification.nil?
      @recipient = chat_room_interlocutor(message.chat_room, message.sender)
      WebNotificationsChannel.broadcast_to(
        @recipient,
        chat_rooms_notifications: user_count_unread_chat_rooms(@recipient),
        total_notifications: user_count_unread(@recipient),
        sound: true
      )
      # if sending from this chat room mark last notification from sender as read
      chat_room_mark_read(message.chat_room, message.sender.id)
      WebNotificationsChannel.broadcast_to(
        message.sender,
        chat_rooms_notifications: user_count_unread_chat_rooms(message.sender),
        total_notifications: user_count_unread(message.sender),
        sound: false
      )
    end
  end

  private

  def render_message(message)
    MessagesController.render(partial: 'messages/message',
                              locals: { message: message, current_user: current_user})
  end

end
