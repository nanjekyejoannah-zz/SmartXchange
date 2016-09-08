class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.string :title, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
