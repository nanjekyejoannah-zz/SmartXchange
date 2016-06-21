class ChangeIdentifierToNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :identifier
    add_column :notifications, :message_id, :integer
  end
end
