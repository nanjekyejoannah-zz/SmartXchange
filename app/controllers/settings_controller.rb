class SettingsController < ApplicationController

  skip_before_action :require_signed_in!, only: [:reset_password, :create_password, :unsubscribe, :update_subscription]
  before_action :correct_user, only: [:change_password, :update_password, :subscribe]

  def show
    @user = User.find(params[:user_id])
  end

  def reset_password
  end

  def create_password
    @user = User.find_by(email: user_params[:email].downcase)
    if @user
      # 6 results in a string length of 8, string length is 4/3 * n
      @new_password = SecureRandom.urlsafe_base64(6)
      @user.update(password: @new_password)
      UserMailer.reset_password(@user, @new_password).deliver_later
      flash[:success] = "Email sent with password reset instructions"
      redirect_to :back
    # maybe make this a pop up in the future
    else
      flash[:error] = "No user found with this email address"
      redirect_to :back
    end
  end

  def change_password
    @user = User.find(params[:user_id])
  end

  def update_password
    # probably need to refactor this, maybe add token
    @user = User.find(params[:user_id])
    if @user.try(:is_password?, user_params[:current_password])
      if user_params[:new_password] == user_params[:password_confirmation]
        if @user.update(password: user_params[:new_password])
          flash[:success] = "Password updated"
          redirect_to user_url(@user)
        else
          flash[:error] = @user.errors.full_messages.to_sentence
          redirect_to :back
        end
      else
        flash[:error] = "New password does not match password confirmation"
        redirect_to :back
      end
    else
      flash[:error] = "Password does not match existing password"
      redirect_to :back
    end
  end

  def unsubscribe
    if params[:id]
      user_id = Rails.application.message_verifier(:unsubscribe).verify(params[:id])
    # since can't call :correct_user on this action add this below for security, to_s instead of looking up user for speed (I think)
    elsif signed_in? && params[:user_id] == current_user.id.to_s
      user_id = params[:user_id]
    else
      flash[:error] = "Must be logged in as correct user or access this link through an email to view this page"
      redirect_to login_url and return
    end
    @user = User.find(user_id)
  end

  def subscribe
    # no links from emails so don't need message verifier
    user_id = params[:user_id]
    @user = User.find(user_id)
  end

  def update_subscription
    @user = User.find(params[:user_id])
    if @user.update(user_params)
      flash[:notice] = 'Subscription changed'
      redirect_to user_url(@user)
    else
      flash[:alert] = 'There was a problem'
      render :unsubscribe
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :current_password, :new_password, :password_confirmation, :subscription)
  end

end
