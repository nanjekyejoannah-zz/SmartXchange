class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :content, null: false
      t.integer :author_id, null: false
      t.integer :board_id, null: false

      t.timestamps
    end
    add_index :posts, :author_id
    
  end
end
