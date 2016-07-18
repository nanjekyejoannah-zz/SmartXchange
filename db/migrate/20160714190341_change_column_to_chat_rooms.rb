class ChangeColumnToChatRooms < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :chat_id
    add_column :notifications, :chat_room_id, :integer
  end
end
