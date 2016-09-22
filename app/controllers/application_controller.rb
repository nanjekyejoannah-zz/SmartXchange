class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?, :correct_user, :correct_chat_room

  before_action :require_signed_in!, :set_timezone

  private

  def current_user
    return nil unless session[:token]
    @current_user ||= User.find_by_session_token(session[:token])
  end

  def signed_in?
    !!current_user
  end

  def sign_out!
    current_user.try(:reset_token!)
    session[:token] = nil
  end

  def sign_in!(user)
    @current_user = user
    session[:token] = user.reset_token!
  end

  def require_signed_in!
    flash[:error] = "Please log in." unless signed_in?
    redirect_to login_url unless signed_in?
    # raise 'Auth Error' unless signed_in? #for $http requests
  end

  def correct_user
    @user = User.find(params[:id])
    # this and correct_chat_room are not set to redirect_to :back because they can only be accessed by typing them in the url and therefore no http_referer is set
    redirect_to users_url unless @user == current_user
  end

  def correct_chat_room
    @chat_room = ChatRoom.find(params[:id])
    # maybe move the end of this method into chat_room.rb
    redirect_to users_url unless (@chat_room.initiator == current_user || @chat_room.recipient == current_user)
  end

  def set_timezone
   min = cookies["time_zone"].to_i
   #  probably refactor later, the time zone offset is - off UTC, but ActiveSupport::TimeZone[] adds it to London time, therefore have to adjust 1 hour
   min += 60
   Time.zone = ActiveSupport::TimeZone[-min.minutes]
  end

  def welcome_new_user(user)
    flash[:success] = "Welcome to smartXchange. Complete your profile and start networking and practicing your language!"
    UserMailer.welcome_email(user).deliver_later
    redirect_to user_url(user)
  end

  def create_post_notifications(vote_or_comment_or_follow_or_post_update, post)
    # first notification for post owner then for followers
    create_post_notification(vote_or_comment_or_follow_or_post_update, post) unless post.owner == vote_or_comment_or_follow_or_post_update.owner
    if post.followers.any?
      post.followers.each do |follower|
        next if vote_or_comment_or_follow_or_post_update.owner == follower
        create_post_notification(vote_or_comment_or_follow_or_post_update, post, follower)
      end
    end
  end

  def create_post_notification(vote_or_comment_or_follow_or_post_update, post, follower = nil)
    @notification = nil
    # maybe refactor, notified only placed here so don't have to declare as an instance variable
    notified = follower ? follower : post.owner
    if post_notification_check(vote_or_comment_or_follow_or_post_update, post, follower)
      @notification = Notification.create!(
        notified_id: notified.id,
        notifier_id: vote_or_comment_or_follow_or_post_update.owner.id,
        notifiable_type: 'Post',
        notifiable_id: post.id,
        sourceable_type: vote_or_comment_or_follow_or_post_update.class.name,
        sourceable_id: vote_or_comment_or_follow_or_post_update.id
      )
    end
    if !@notification.nil?
      WebNotificationsChannel.broadcast_to(
        notified,
        posts_notifications: user_count_unread_posts(notified),
        total_notifications: user_count_unread(notified),
        sound: true
      )
    end
  end

  def destroy_post_notifications(follow, post)
    # destroy all post notifications for the follower if it exists, maybe refactor, doesn't matter if its read or not
    post.notifications.where(sourceable_type: 'Follow', sourceable_id: follow.id).destroy_all
  end

  def create_follow(post)
    return if post.followers.include?(current_user)
    return if post.owner == current_user
    follow = Follow.new(follower_id: current_user.id)
    post.follows << follow
    follow
  end

  def destroy_follow(post)
    return unless post.followers.include?(current_user)
    # shouldn't be a problem since owner can't be follower but a precautionary line of code
    return if post.owner == current_user
    # should be only 1 follows per person per post, may need to refactor
    follow = post.follows.where(follower_id: current_user.id).first
    follow.destroy
  end

end
