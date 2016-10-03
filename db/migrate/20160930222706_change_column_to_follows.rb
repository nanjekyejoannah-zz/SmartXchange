class ChangeColumnToFollows < ActiveRecord::Migration[5.0]
  def change
    change_column :follows, :follower_id, :integer, null: false
  end
end
