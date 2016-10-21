task :send_reminder => :environment do
  UserMailer.weekly_notifications(User.first, 1).deliver
end
