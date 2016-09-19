module BoardsHelper

  def board_has_unread?
    @board = Board.first
    # hack job here and below method don't want to add another column to users maybe refactor
    if @board.updated_at > current_user.updated_at
      return true
    end
    false
  end

  def board_mark_read
    current_user.update(updated_at: Time.now)
  end

end
