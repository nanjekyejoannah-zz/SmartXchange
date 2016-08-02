class UsersController < ApplicationController
  #add location

  skip_before_action :require_signed_in!, only: [:new, :create]
  before_action :correct_user,   only: [:update, :destroy]

  def new
    @user_count = User.all.count
    redirect_to users_url if signed_in?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in!(@user)
      flash[:success] = "Welcome to smartXchange!"
      UserMailer.welcome_email(@user).deliver_later
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
  def all
    @users = User.all.paginate(page: params[:page], per_page: 12)
    render :index
  end

  def active
    @users = User.where(active: true).paginate(page: params[:page], per_page: 12)
    render :index
  end

  def chat_bots
    @users = User.where(id: 6).paginate(page: params[:page], per_page: 12)
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

  # Call this in rails console to email everyone without redirect_to
  # def notify_all
  #   redirect_to :back unless current_user.id == 1
  #   @users = User.all
  #   @users.each do |user|
  #     UserMailer.notify_email(user).deliver_now
  #   end
  # end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to '/users/new'
  end

  private

  def user_params
    params.require(:user).permit(:password, :email, :name, :age, :title, :language, :language_level, :image)
  end

end
