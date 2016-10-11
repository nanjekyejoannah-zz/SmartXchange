class RemoveSubscriptionToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :subscription
  end
end
