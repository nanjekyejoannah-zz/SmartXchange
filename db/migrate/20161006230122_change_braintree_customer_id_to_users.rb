class ChangeBraintreeCustomerIdToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :string
    add_column :users, :braintree_customer_id, :string
  end
end
