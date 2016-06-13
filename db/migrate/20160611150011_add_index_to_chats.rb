class AddIndexToChats < ActiveRecord::Migration
  def change
    add_index :chats, :created_at
  end
end
