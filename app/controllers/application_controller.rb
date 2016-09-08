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
    redirect_to :back unless @user == current_user
  end

  def correct_chat_room
    @chat_room = ChatRoom.find(params[:id])
    # maybe move the end of this method into chat_room.rb
    redirect_to :back unless (@chat_room.initiator == current_user || @chat_room.recipient == current_user)
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

end
