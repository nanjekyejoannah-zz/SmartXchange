class AddTitleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :title, :string, null: false, default: 'Baller at Life'
  end
end
