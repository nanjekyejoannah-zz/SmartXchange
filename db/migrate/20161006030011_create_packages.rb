class CreatePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :packages do |t|
      t.string :type, null: false
      t.string :description, null: false

      t.timestamps
    end
    add_index :packages, :type, unique: true
  end
end
