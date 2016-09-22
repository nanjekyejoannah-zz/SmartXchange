module BoardsHelper

  def board_has_unread?(board)
    # hack job here and below method don't want to add another column to users maybe refactor
    if board.updated_at > current_user.updated_at + 1
      return true
    end
    false
  end

  def board_mark_read
    current_user.update(updated_at: Time.now)
  end

end
