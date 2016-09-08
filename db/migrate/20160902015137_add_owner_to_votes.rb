class AddOwnerToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :owner_id, :integer
  end
end
