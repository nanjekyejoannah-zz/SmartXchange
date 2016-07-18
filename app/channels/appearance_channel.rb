# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class AppearanceChannel < ApplicationCable::Channel

  def subscribed
    current_user.appear
  end

  def unsubscribed
    current_user.disappear
  end

  # took out (data)
  def appear
    current_user.appear
    # on: data['appearing_on']
  end

  def disappear
    current_user.disappear
  end
end
