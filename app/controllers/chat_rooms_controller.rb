class ChatRoomsController < ApplicationController

  before_action :correct_chat_room, only: [:show, :destroy]

  include ChatRoomsHelper

  def index
    # includes is for chat room helper methods called when listing a chat room
    @chat_rooms = ChatRoom.includes(:notifications, :recipient, :initiator).involving(current_user)
  end

  def new
    @chat_room = ChatRoom.new
  end

  def show
    @chat_room ||= ChatRoom.find_by(id: params[:id])
    @messages = @chat_room.messages.includes(:sender)
    @message = Message.new
    @receiver = chat_room_interlocutor(@chat_room, current_user)
    # updating notifications for user as they visit chat room
    chat_room_mark_read(@chat_room, current_user.id)
    render :show #needed since create action redirects here, needs to know what template to show
  end

  def create
    @chat_room = ChatRoom.between(current_user.id, chat_room_params[:recipient_id], current_user.language).first
    if !@chat_room
      # set up right now so that the title of the chat room is the initiator's
      @chat_room = ChatRoom.create!(initiator_id: current_user.id, recipient_id: chat_room_params[:recipient_id], title: current_user.language)
    end
    show
  end

  def destroy
    @chat_room = ChatRoom.find(params[:id])
    @chat_room.destroy
    respond_to  do |format|
      format.js
    end
  end

  private

  def chat_room_params
    params.require(:chat_room).permit(:recipient_id)
  end
end
