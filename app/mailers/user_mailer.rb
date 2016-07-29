class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url  = 'http://www.smartxchange.es/login'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: 'Welcome to smartXchange')
  end

  def notify_email(user)
    # change this to users who want notifications eventually
    # comes in as active record relation
    @user = user
    @url  = 'http://www.smartxchange.es/login'
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    attachments['logo.jpg'] = File.read("#{Rails.root}/app/assets/images/logo square.png")
    mail(to: email_with_name, subject: 'Latest updates to smartXchange')
  end
end
