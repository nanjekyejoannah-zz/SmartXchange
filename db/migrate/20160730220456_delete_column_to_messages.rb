class DeleteColumnToMessages < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :chat_id
  end
end
