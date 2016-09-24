class ChangeColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :nationality, :string, null: false, default: "Spanish"
  end
end
