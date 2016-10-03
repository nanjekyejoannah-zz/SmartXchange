class AddMatchesTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :matches_token, :string
    add_column :users, :matches_sent_at, :datetime
  end
end
