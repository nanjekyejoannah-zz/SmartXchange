module UserHelper

  #false in quotations works on heroku but not local server
  def user_count_unread(user)
    user.notifications.where(read: false).count
  end

  def user_convert_language_level (level)
    if level == 1
      return "A1 - beginner"
    elsif level == 2
      return "A2 - elementary"
    elsif level == 3
      return "B1 - intermediate"
    elsif level == 4
      return "B2 - upper intermediate"
    elsif level == 5
      return "C1 - advanced"
    elsif level == 6
      return "C2 - master"
    end
  end

end
