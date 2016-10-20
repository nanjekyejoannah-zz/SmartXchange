class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?

  before_action :require_signed_in!, :set_timezone, :protect_from_host_header_attack

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

  def normal_sign_in
    redirect_to(session[:return_to] || users_path)
    session[:return_to] = nil
  end

  def require_signed_in!
    unless signed_in?
      flash[:error] = "Please log in."
      session[:return_to] = request.url
      redirect_to login_path
    end
    # raise 'Auth Error' unless signed_in? #for $http requests
  end

  def correct_user?
    # need this for settings maybe refactor
    id = params[:user_id] ? params[:user_id] : params[:id]
    @user = User.find(id)
    unless @user == current_user
      flash[:error] = "Unauthorized access"
      # this and correct_chat_room? are not set to redirect_to :back because they can only be accessed by typing them in the url and therefore no http_referer is set
      redirect_to users_path
      return false
    end
    true
  end

  def correct_chat_room?
    @chat_room = ChatRoom.find(params[:id])

    # maybe move the end of this method into chat_room.rb
    unless (@chat_room.initiator == current_user || @chat_room.recipient == current_user)
      flash[:error] = "Unauthorized access"
      redirect_to users_path
    end
  end

  def set_timezone
    min = cookies["time_zone"].to_i
    #  probably refactor later, the time zone offset is - off UTC, but ActiveSupport::TimeZone[] adds it to London time, therefore have to adjust 1 hour
    min += 60
    Time.zone = ActiveSupport::TimeZone[-min.minutes]
  end

  def welcome_new(user)
    flash[:success] = "Welcome to smartXchange. Complete your profile and start networking and practicing your language! Make sure to update your nationality so that your country's flag will be displayed to others when they talk with you"
    UserMailer.welcome_new(user).deliver_later
    redirect_to user_path(user)
  end

  def protect_from_host_header_attack
    env['HTTP_HOST'] = default_url_options.fetch(:host, env['HTTP_HOST'])
  end

end
