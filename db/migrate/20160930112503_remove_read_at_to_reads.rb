class RemoveReadAtToReads < ActiveRecord::Migration[5.0]
  def change
    remove_column :reads, :read_at
  end
end
