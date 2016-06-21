class RemoveUnreadMessagesFromChats < ActiveRecord::Migration
  def change
    remove_column :chats, :unread_messages
  end
end
