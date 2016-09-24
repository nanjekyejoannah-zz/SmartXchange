module MessagesHelper

  def message_self_or_other(message, user)
    message.sender == user ? "self" : "other"
  end

  def message_convert_level_to_img(message)
    # The more faded it is the worse the level
    filtered = (1 - message.sender.language_level.to_f / 6)
    filtered = number_to_percentage(filtered*100)
    image_tag("country-flags/#{message.sender.language}-flag-circular.png", :style => "-webkit-filter: grayscale(#{filtered});", alt: "#{message.sender.language}")
  end

end
