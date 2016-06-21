module UserHelper

  def user_count_unread(user)
    user.notifications.where(read: 'false').count
  end

end
