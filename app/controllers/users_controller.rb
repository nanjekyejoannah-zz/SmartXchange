class UsersController < ApplicationController
  #add location

  skip_before_action :require_signed_in!, only: [:new, :create]
  before_action :correct_user,   only: [:update]

  def new
    redirect_to users_url if signed_in?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in!(@user)
      flash[:success] = "Welcome to the smartXchange!"
      redirect_to users_url
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def index
    #will implement matching algorithm here or someone else
    @users = User.where(language: current_user.language).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def show
    @user = User.find(params[:id])
    @chat_room = ChatRoom.new
    render :show
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to user_url(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to :back
    end
  end

  # maybe refactor these two to be in a frontend framework or move to protected
  def all_users
    @users = User.all.paginate(page: params[:page], per_page: 12)
    render :index
  end

  def active_users
    @users = User.where(active: true).paginate(page: params[:page], per_page: 12)
    render :index
  end

  # may get rid of these
  def spanish
    @users = User.where(language: 'Spanish').paginate(page: params[:page], per_page: 12)
    render :index
  end

  def italian
    @users = User.where(language: 'Italian').paginate(page: params[:page], per_page: 12)
    render :index
  end

  def english
    @users = User.where(language: 'English').paginate(page: params[:page], per_page: 12)
    render :index
  end

  def french
    @users = User.where(language: 'French').paginate(page: params[:page], per_page: 12)
    render :index
  end

  def german
    @users = User.where(language: 'German').paginate(page: params[:page], per_page: 12)
    render :index
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :name, :age, :title, :language, :language_level, :image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(users_url) unless @user == current_user
  end

end
