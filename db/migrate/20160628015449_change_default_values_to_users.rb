class ChangeDefaultValuesToUsers < ActiveRecord::Migration
  def change
    change_column :users, :title, :string, null: false, default: 'Finding inner peace'
    change_column :users, :name, :string, null: false, default: 'Buddha'
  end
end
