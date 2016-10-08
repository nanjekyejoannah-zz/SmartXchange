class AddPriceToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :price, :decimal, :precision => 8, :scale => 2
  end
end
