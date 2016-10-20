class AddUniqueIndexOnChatRoomIdToReviews < ActiveRecord::Migration[5.0]
  def change
    add_index :reviews, [:chat_room_id, :reviewer_id], unique: true
  end
end
