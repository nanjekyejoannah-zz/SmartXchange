class AddSourceableToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :sourceable_type, :string
    add_column :notifications, :sourceable_id, :integer
  end
end
