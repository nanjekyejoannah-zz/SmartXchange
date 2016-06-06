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

  private

  def user_params
    params.require(:user).permit(:password, :email)
  end

end
