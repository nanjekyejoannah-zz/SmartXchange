class RenameColumnsToCommentsAndPosts < ActiveRecord::Migration[5.0]
  def change
    rename_column :comments, :author_id, :owner_id
    rename_column :posts, :author_id, :owner_id
  end
end
