class SessionsController < ApplicationController
  before_action :require_signed_in!, only: [:destroy]

  def new
    redirect_to root_url if signed_in?
  end

  def create
    @user = User.find_by_credentials(params[:user])
    if @user
      sign_in!(@user)
      redirect_to root_url
    else
      flash.now[:errors] = "Invalid email and/or password"
      render :new
    end
  end

  def destroy
    sign_out!
    redirect_to login_url
  end

end
