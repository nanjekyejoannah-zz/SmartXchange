class UserController < ApplicationController

  #add location

  before_action :require_signed_in!, only: [:destroy, :show, :index]

  def new
    redirect_to root_url if signed_in?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in!(@user)
      flash[:success] = "Welcome to the SmartXchange!"
      redirect_to root_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def index
    #will implement matching algorithm here or someone else
    @users = User.all
    render :index
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def update
    @user = User.find(params[:id])
    # fail
    if @user.update(user_params)
      redirect_to user_url(@user)
      flash[:success] = "Profile updated"
    else
      flash.now[:errors] = @user.errors.full_messages
      redirect_to :back
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :name, :age, :title, :language, :language_level, :image)
  end

  def image_params

  end

end
