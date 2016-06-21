class ChangeUserColumnToMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :user_id
    add_column :messages, :sender_id, :integer, index: true, foreign_key: true
  end
end
