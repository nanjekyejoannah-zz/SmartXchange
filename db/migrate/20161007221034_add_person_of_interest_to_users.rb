class AddPersonOfInterestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :person_of_interest, :boolean, null: false, default: false
  end
end
