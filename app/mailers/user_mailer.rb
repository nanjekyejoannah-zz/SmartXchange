class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url  = 'http://www.smartxchange.es/login'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    attachments['logo.jpg'] = File.read("#{Rails.root}/app/assets/images/logo square.png")
    mail(to: email_with_name, subject: 'Welcome to smartXchange')
  end

  def notify_email(user)
    # change this to users who want notifications eventually
    @user = user
    @url  = 'http://www.smartxchange.es/login'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    attachments['logo.jpg'] = File.read("#{Rails.root}/app/assets/images/logo square.png")
    mail(to: email_with_name, subject: 'Latest updates to smartXchange')
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
