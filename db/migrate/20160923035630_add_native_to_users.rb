class AddNativeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nationality, :string
  end
end
