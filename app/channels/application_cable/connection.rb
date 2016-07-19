# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      session = cookies.encrypted[Rails.application.config.session_options[:key]]
      self.current_user = User.find_by_session_token(session["token"])
      # using devise
      # self.current_user = find_verified_user
      # may need to refactor later, using try to avoid getting error if user isn't logged in
      logger.add_tags 'ActionCable', current_user.try(:email)
    end

    # using devise
    # protected
    #
    # def find_verified_user # this checks whether a user is authenticated with devise
    #   if verified_user = env['warden'].user
    #     verified_user
    #   else
    #     reject_unauthorized_connection
    #   end
    # end

  end
end
