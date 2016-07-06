class ChatsController < ApplicationController
  include ChatsHelper
  before_action :require_signed_in!, only: [:create, :index, :show]

  def create
    if Chat.between(params[:sender_id],params[:recipient_id]).present?
      @chat = Chat.between(params[:sender_id],params[:recipient_id]).first
    else
      @chat = Chat.create!(chat_params)
    end

    show
    # render json: { chat_id: @chat.id }
  end

  def show
    @chat ||= Chat.find(params[:id])
    @receiver = @chat.recipient
    @messages = @chat.messages
    @message = Message.new
    @receiver = chat_interlocutor(@chat)
    render :show
  end

  #returns all chats associated with given user
  def index
    @chats = Chat.involving(current_user)
    render :index
  end

  def new
    #a post request which calls chats#create is sent via javascript
  end

  private
  def chat_params
    params.permit(:sender_id, :recipient_id)
  end

end
