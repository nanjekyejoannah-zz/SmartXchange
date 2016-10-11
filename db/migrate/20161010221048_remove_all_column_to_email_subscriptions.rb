class RemoveAllColumnToEmailSubscriptions < ActiveRecord::Migration[5.0]
  def change
    remove_column :email_subscriptions, :all
  end
end
