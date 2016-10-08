class AddBraintreeCustomerIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :string, :braintree_customer_id
  end
end
