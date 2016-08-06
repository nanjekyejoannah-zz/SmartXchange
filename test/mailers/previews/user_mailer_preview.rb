# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.first)
  end

  def notify_email
    UserMailer.notify_email(User.first, 1)
  end

  def reset_password
    UserMailer.reset_password(User.first, SecureRandom.urlsafe_base64(6))
  end
end
