class ChatRoomsController < ApplicationController

  before_action :correct_chat_room, only: [:show]

  include ChatRoomsHelper

  def index
    # Need to refactor and make sql query faster with includes or some other solution
    @chat_rooms = ChatRoom.includes(:messages, :notifications, :recipient, :initiator).involving(current_user).sort {|c1,c2| sort_method(c1) <=> sort_method(c2) }
  end

  def sort_method(chat_room)
    last_modified = chat_room.messages.last ? chat_room.messages.last.created_at : chat_room.created_at
    Time.now - last_modified
  end

  def new
    @chat_room = ChatRoom.new
  end

  def show
    @chat_room ||= ChatRoom.includes(:messages, {messages: :sender}).find_by(id: params[:id])
    @message = Message.new
    @receiver = chat_room_interlocutor(@chat_room, current_user)
    # updating notifications for user as they visit chat room
    chat_room_mark_read(@chat_room.id, current_user.id)
    render :show
  end

  def create
    initiator = current_user
    if ChatRoom.between(initiator,chat_room_params[:recipient_id]).present?
      @chat_room = ChatRoom.between(initiator,chat_room_params[:recipient_id]).first
    else
      # set right now that the title of the chat room is the initiator's
      @chat_room = ChatRoom.create!(initiator_id: initiator.id, recipient_id: chat_room_params[:recipient_id], title: initiator.language)
    end
    show
  end

  def destroy
    @chat_room = ChatRoom.find(params[:id])
    @chat_room.destroy
    redirect_to :back
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:recipient_id)
  end
end
