class AddNewMessageToEmailSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :email_subscriptions, :new_message, :boolean, null: false, default: true
  end
end
