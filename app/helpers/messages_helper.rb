module MessagesHelper

  def message_self_or_other(message, user)
    message.sender == user ? "self" : "other"
  end

  def message_convert_level_to_img(message)
    # The more faded it is the worse the level
    filtered = (1 - message.sender.language_level.to_f / 6)
    filtered = number_to_percentage(filtered*100)
    if message.sender.language == "Spanish"
      image_tag('spain-flag-circular.gif', :style => "-webkit-filter: grayscale(#{filtered});", alt: 'Spanish')
    elsif message.sender.language == "Italian"
      image_tag('italy-flag-circular.gif', :style => "-webkit-filter: grayscale(#{filtered});", alt: 'Italian')
    elsif message.sender.language == "German"
      image_tag('germany-flag-circular.gif', :style => "-webkit-filter: grayscale(#{filtered});", alt: 'German')
    elsif message.sender.language == "English"
      image_tag('united-kingdom-flag-circular.png', :style => "-webkit-filter: grayscale(#{filtered});", alt: 'English')
    elsif message.sender.language == "French"
      image_tag('france-flag-circular.gif', :style => "-webkit-filter: grayscale(#{filtered});", alt: 'French')
    end
  end

end
