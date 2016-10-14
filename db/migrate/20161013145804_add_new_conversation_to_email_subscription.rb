class AddNewConversationToEmailSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :email_subscriptions, :new_conversation, :boolean, null: false, default: true
  end
end
