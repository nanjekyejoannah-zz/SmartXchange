class UserMailer < ApplicationMailer
  # Call this in rails console to email everyone without redirect_to, make sure to do <9 every 10min after initial batch due to smtp settings
  # @users = User.all
  # @users.each do |user|
  #   if user_count_unread(user) > 0
  #     UserMailer.notify_email(user, user_count_unread(user)).deliver_now
  #   end
  # end

  def welcome_email(user)
    @user = user
    @url  = 'http://www.smartxchange.es/login'
    @url_tutorial = 'http://www.smartxchange.es/about#video'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    attachments['logo.jpg'] = File.read("#{Rails.root}/app/assets/images/logo-square.png")
    mail(to: email_with_name, subject: 'Welcome to smartXchange')
  end

  def notify_email(user, notifications)
    # change this to users who want notifications eventually
    @user = user
    @notifications = notifications
    @url  = 'http://www.smartxchange.es/login'
    @url_tutorial = 'http://www.smartxchange.es/about#video'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    attachments['logo.jpg'] = File.read("#{Rails.root}/app/assets/images/logo-square.png")
    mail(to: email_with_name, subject: 'smartXchange Notifications')
  end

  def monthly_update(user, notifications)
    @user = user
    @notifications = notifications
    @url  = 'http://www.smartxchange.es/login'
    @url_tutorial = 'http://www.smartxchange.es/about#video'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    attachments['logo.jpg'] = File.read("#{Rails.root}/app/assets/images/logo-square.png")
    mail(to: email_with_name, subject: 'smartXchange Update')
  end

  def reset_password(user, password)
    @user = user
    @password = password
    @url  = 'http://www.smartxchange.es/login'
    @url_reset = 'http://www.smartxchange.es/users/'+@user.id.to_s+'/change_password'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Password reset, smartXchange')
  end
end
