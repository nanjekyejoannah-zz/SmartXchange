class AddIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, [:chat_id, :created_at]
    add_index :messages, :created_at
  end
end
