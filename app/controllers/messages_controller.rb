class MessagesController < ApplicationController
  include MessagesHelper

  before_action :require_signed_in!

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.build(message_params)
    @message.sender_id = current_user.id
    if @message.save!
      create_notification(@chat, @message)
      @path = chat_path(@chat)
    end

  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def create_notification(chat,message)
    #refactor later
    Notification.create!(notified_id: message.sender == message.chat.sender ? message.chat.recipient.id : message.chat.sender.id,
                        notifier_id: current_user.id,
                        chat_id: chat.id,
                        message_id: message.id
                        )

    end

end
