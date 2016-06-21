class AddColumnToChats < ActiveRecord::Migration
  def change
    add_column :chats, :unread_messages, :integer, null: false, default: 0
  end
end
