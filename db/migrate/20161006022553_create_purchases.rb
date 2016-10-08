class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.integer :buyer_id, null: false
      t.integer :package_id, null: false

      t.timestamps
    end
    add_index :purchases, [:buyer_id, :package_id], unique: true
    add_index :purchases, :buyer_id
  end
end
