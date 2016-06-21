class ChangeReadColumnToNotifications < ActiveRecord::Migration
  def change
    change_column :notifications, :read, :boolean, null: false, default: 'false'
  end
end
