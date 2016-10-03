# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.first)
  end

  def notify_email
    UserMailer.notify_email(User.first, 1)
  end

  def monthly_update
    UserMailer.monthly_update(User.first, 2)
  end

  def reset_password
    UserMailer.reset_password(User.first, SecureRandom.urlsafe_base64(6))
  end

  def matches_email
    UserMailer.matches_email(User.first)
  end

  def match_email
    UserMailer.match_email(User.first, User.second)
  end

  def warning_email
    UserMailer.warning_email(User.first)
  end
end
