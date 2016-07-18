class ChatRoomsController < ApplicationController
  include ChatRoomsHelper

  def index
    # Need to refactor and make sql query faster with includes or some other solution
    @chat_rooms = ChatRoom.involving(current_user)
  end

  def new
    @chat_room = ChatRoom.new
  end

  def show
    @chat_room ||= ChatRoom.includes(:messages, {messages: :sender}).find_by(id: params[:id])
    @message = Message.new
    @receiver = chat_room_interlocutor(@chat_room, current_user)
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

  private

  def chat_room_params
    params.require(:chat_room).permit(:recipient_id)
  end
end
