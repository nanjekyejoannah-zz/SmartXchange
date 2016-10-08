class RenameTypeColumnToPackages < ActiveRecord::Migration[5.0]
  def change
    rename_column :packages, :type, :classification
  end
end
