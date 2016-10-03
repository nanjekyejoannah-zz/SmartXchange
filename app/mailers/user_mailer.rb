class UserMailer < ApplicationMailer
  # Call this in rails console to email everyone without redirect_to, make sure to do <9 every 10min after initial batch due to smtp settings
  # @users = User.all
  # @users[0..48].each do |user|
  #     UserMailer.monthly_update(user, user_count_unread(user)).deliver_now
  # end
  # @users.each do |user|
  #   if user_count_unread(user) > 0
  #     UserMailer.notify_email(user, user_count_unread(user)).deliver_now
  #   end
  # end

  before_action :set_urls_and_attachments
  # bit of a hack, maybe refactor need @user to be set before sending
  after_action :prevent_delivery_to_unsubscribed, only: [:monthly_update]

  def welcome_email(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Welcome to smartXchange')
  end

  def notify_email(user, notifications)
    # change this to users who want notifications eventually
    @user = user
    @notifications = notifications
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'smartXchange Notifications')
  end

  def monthly_update(user, notifications)
    @user = user
    @notifications = notifications
    @unsubscribe_hash = Rails.application.message_verifier(:unsubscribe).generate(@user.id)
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'smartXchange enters its third month since launch')
  end

  def reset_password(user, password)
    @user = user
    @password = password
    @url_change_password = "http://www.smartxchange.es/users/#{@user.id}/settings/change_password"
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Password reset, smartXchange')
  end

  def matches_email(user)
    @user = user
    @matches = User.where(language: @user.language)
    @matches_token = @user.create_matches_token!
    @url_email_match = "http://www.smartxchange.es/users/#{@user.id}/email_match/#{@matches_token}/"
    if @matches.any?
      @linkedin_img_not_set = true
      @matches.each do |match|
        attachments.inline["#{match.name}.jpg"] = File.read("#{Rails.root}/public/#{match.image.small_thumb.url}")
        # probably refactor, only do when needed so doesn't send as attachment if unused
        if @linkedin_img_not_set && match.linkedin
          attachments.inline['linkedin.png'] = File.read("#{Rails.root}/app/assets/images/linkedin-button-small.png")
          @linkedin_img_not_set = false
        end
      end
    end
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Have you messaged these language practice peers?')
  end

  def match_email(user, match)
    @user = user
    @match = match
    @url_user = "http://www.smartxchange.es/users/#{@user.id}"
    attachments.inline['linkedin.png'] = File.read("#{Rails.root}/app/assets/images/linkedin-button-small.png") if @user.linkedin
    attachments.inline["#{@user.name}.jpg"] = File.read("#{Rails.root}/public/#{@user.image.small_thumb.url}")
    email_with_name = %("#{@match.name}" <#{@match.email}>)
    mail(to: email_with_name, subject: "#{@user.name} wants to practice #{@user.language}")
  end

  def warning_email(user)
    @user = user
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Suspicious Activity')
  end

  private

  def set_urls_and_attachments
    @url  = 'http://www.smartxchange.es/login'
    @url_tutorial = 'http://www.smartxchange.es/about#video'
    @url_mobile_tutorial = 'http://www.smartxchange.es/about#video-mobile'
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
  end

  def prevent_delivery_to_unsubscribed
    mail.perform_deliveries = false unless @user.subscription
  end

end
