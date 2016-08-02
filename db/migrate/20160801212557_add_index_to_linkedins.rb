class AddIndexToLinkedins < ActiveRecord::Migration[5.0]
  def change
    add_index :linkedins, :user_id, unique: true
  end
end
