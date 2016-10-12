class UserMailer < ApplicationMailer
  # Call this in rails console to email everyone without redirect_to, make sure to do <9 every 10min after initial batch due to smtp settings
  # @users = User.all
  # @users[0..48].each do |user|
  #     UserMailer.monthly_update(user, user_count_unread(user)).deliver_now
  # end
  # @users.each do |user|
  #   if user_count_unread(user) > 0
  #     UserMailer.weekly_notifications(user, user_count_unread(user)).deliver_now
  #   end
  # end

  before_action :set_urls_and_attachments
  # bit of a hack, maybe refactor need @user to be set before sending, welcome new will always be true just there so doesn't enter method
  after_action :prevent_delivery_to_unsubscribed, except: [:welcome_new, :reset_password, :suspicious_activity, :premium_subscribe, :premium_unsubscribe]

  def welcome_new(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'Welcome to smartXchange')
  end

  def weekly_notifications(user, notifications)
    # change this to users who want notifications eventually
    @user = user
    @notifications = notifications
    # built with google url builder
    add_campaign('?utm_source=notifications_email&utm_medium=email&utm_campaign=october_notifications')
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'smartXchange Notifications')
  end

  def monthly_update(user, notifications)
    @user = user
    @notifications = notifications
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'smartXchange enters its third month since launch')
  end

  def reset_password(user, password)
    @user = user
    @password = password
    @url_change_password = "http://www.smartxchange.es/users/#{@user.id}/settings/change_password"
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'Password reset, smartXchange')
  end

  def language_matches(user)
    @user = user
    @matches = @user.sort_method[0..4]
    @matches_token = @user.create_matches_token!
    @url_email_match = "http://www.smartxchange.es/users/#{@user.id}/email_match/#{@matches_token}/"
    if @matches.any?
      @linkedin_img_not_set = true
      @matches.each do |match|
        fetch_user_image(match)
        # probably refactor, only do when needed so doesn't send as attachment if unused
        if @linkedin_img_not_set && match.linkedin
          attachments.inline['linkedin.png'] = File.read("#{Rails.root}/app/assets/images/linkedin-button-small.png")
          @linkedin_img_not_set = false
        end
      end
    end
    # for login link @url
    add_campaign('?utm_source=matches_email&utm_medium=email&utm_campaign=october_matches')
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'Have you messaged these language practice peers?')
  end

  def notify_match(interested_user, matched_user)
    @interested_user = interested_user
    # set as @user instead of @matched_user so don't have to change unsubscribe logic
    @user = matched_user
    @url_interested_user = "http://www.smartxchange.es/users/#{@interested_user.id}"
    attachments.inline['linkedin.png'] = File.read("#{Rails.root}/app/assets/images/linkedin-button-small.png") if @interested_user.linkedin
    fetch_user_image(@interested_user)
    # for view profile link @url_user
    add_campaign('?utm_source=matches_email&utm_medium=email&utm_campaign=october_matches')
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: "#{@interested_user.name} wants to practice #{@interested_user.language}")
  end

  def suspicious_activity(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'Suspicious Activity')
  end

  def premium_subscribe(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'Welcome to smartXchange Premium')
  end

  def premium_unsubscribe(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    set_unsubscribe_hash
    mail(to: email_with_name, subject: 'Sorry to see you leave')
  end

  private

  def set_urls_and_attachments
    @url  = 'http://www.smartxchange.es/login'
    @url_tutorial = 'http://www.smartxchange.es/about#video'
    @url_mobile_tutorial = 'http://www.smartxchange.es/about#video-mobile'
    @url_premium = 'http://www.smartxchange.es/about#premium'
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
  end

  def add_campaign(string)
    @url += "#{string}"
    @url_tutorial = "http://www.smartxchange.es/about#{string}#video"
    @url_mobile_tutorial = "http://www.smartxchange.es/about#{string}#video-mobile"
    @url_premium = "http://www.smartxchange.es/about#{string}#premium"
    @url_interested_user += "#{string}" if @url_interested_user
  end

  def prevent_delivery_to_unsubscribed
    mail.perform_deliveries = false unless @user.email_subscription.send(action_name)
  end

  def set_unsubscribe_hash
    @unsubscribe_hash = Rails.application.message_verifier(:unsubscribe).generate(@user.id)
  end

  def fetch_user_image(user)
    # in production .url works as url should, but in development .url works as path and vice versa
    if Rails.env.production?
      # maybe refactor, if no image uploaded, need to fetch the image from default_url method, which for some reason wasn't finding the file - Errno::ENOENT: No such file or directory @ rb_sysopen - http://www.smartxchange.es/images/fallback/user/small_thumb_default.png  even though the file exists and the link works (also wasn't able to use Rails.root since prepends 'app' to path), but this method works with remote fetch
      # need to use .url path without Rails.root due to images stored on amazon s3 servers
      # .path shows up nil for default_url call
      image_url = user.image.small_thumb.path ? user.image.small_thumb.url : "http://www.smartxchange.es#{user.image.small_thumb.url}"
      attachments.inline["#{user.name}.jpg"] = open(image_url).read
    else
      attachments.inline["#{user.name}.jpg"] = File.read("#{Rails.root}/public/#{user.image.small_thumb.url}")
    end
  end

end
