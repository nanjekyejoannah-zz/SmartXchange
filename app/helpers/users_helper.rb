module UsersHelper

  #false in quotations works on heroku but not local server
  def user_count_unread(user)
    user.notifications.where(read: false).count
  end

  def user_convert_language_level(level)
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

  def user_convert_title_to_img(title)
    if title == "Spanish"
      image_tag('spain-flag.gif', alt: 'Spanish')
    elsif title == "Italian"
      image_tag('italy-flag.gif', alt: 'Italian')
    elsif title == "German"
      image_tag('germany-flag.gif', alt: 'German')
    elsif title == "English"
      image_tag('united-kingdom-flag.jpg', alt: 'English')
    elsif title == "French"
      image_tag('france-flag.gif', alt: 'French')
    end
  end

end
