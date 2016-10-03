class AddSubscriptionToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :subscription, :boolean, null: false, default: true
  end
end
