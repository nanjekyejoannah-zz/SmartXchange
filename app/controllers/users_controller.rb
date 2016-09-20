require 'will_paginate/array'
class UsersController < ApplicationController
  #add location

  skip_before_action :require_signed_in!, only: [:new, :create, :reset_password, :create_password]
  before_action :correct_user, only: [:update, :destroy, :change_password, :update_password]

  def new
    @user_count = User.all.count - (User.all.count % 10)
    redirect_to users_url if signed_in?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in!(@user)
      welcome_new_user(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
      # redirect_to signup_url
    end
  end

  def index
    #will implement matching algorithm here or someone else
    @users = User.where(language: current_user.language).includes(:linkedin).sort {|u1, u2| sort_method(u2) <=> sort_method(u1) }.paginate(page: params[:page], per_page: 12)
    render :index
  end

  def sort_method(user)
    denominator = user.language_level > current_user.language_level ? (user.language_level.to_f * 2) : (current_user.language_level.to_f * 2)
    sort = (user.language_level.to_f + current_user.language_level.to_f) / denominator
    sort *= 1.5 if current_user.location && user.location && current_user.distance_from(user) < 50
    sort
  end

  def show
    @user = User.find(params[:id])
    @chat_room = ChatRoom.new
    render :show
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # maybe refactor so array isn't generated everytime
      messages = ["Profile updated! Now it's time for some networking", "Profile updated! Bored? Post something to the Board and see how many votes it can get :)"]
      flash[:success] = messages.sample
      redirect_to user_url(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  # maybe refactor these two to be in a frontend framework or move to protected
  def all
    @users = User.all.includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def active
    @users = User.where(active: true).includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def chat_bots
    @users = User.where(id: 6).includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  # may get rid of these
  def spanish
    @users = User.where(language: 'Spanish').includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def italian
    @users = User.where(language: 'Italian').includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def english
    @users = User.where(language: 'English').includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def french
    @users = User.where(language: 'French').includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def german
    @users = User.where(language: 'German').includes(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to '/users/new'
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
    @user = User.find(params[:id])
  end

  def update_password
    # probably need to refactor this, maybe add timer
    @user = User.find(params[:id])
    if @user.try(:is_password?, user_params[:temp_password])
      if user_params[:password] == user_params[:password_confirmation]
        if @user.update(password: user_params[:password])
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

  def search
    search = user_params[:search]
    # need references to make it work, maybe refactor later
    @users = User.includes(:linkedin).where('name LIKE :search OR title LIKE :search OR language LIKE :search OR location LIKE :search OR cast(age as text) LIKE :search OR linkedins.industry LIKE :search OR linkedins.summary LIKE :search', search: "%#{search}%").references(:linkedin).paginate(page: params[:page], per_page: 12)
    render :index
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :name, :age, :title, :language, :language_level, :image, :temp_password, :password_confirmation, :search)
  end

end
