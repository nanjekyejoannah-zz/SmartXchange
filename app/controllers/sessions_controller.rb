class SessionsController < ApplicationController

  skip_before_action :require_signed_in!, only: [:new, :create, :create_linkedin, :new_linkedin, :existing_linkedin]

  # probably need to refactor class variable at some point
  @@existing = false
  @@add = false
  @@update = false

  def new
    redirect_to users_url if signed_in?
  end

  def create
    @user = User.find_by_credentials(params[:user])
    if @user
      sign_in!(@user)
      redirect_to users_url
    else
      flash[:error] = "Invalid email and/or password"
      redirect_to login_url
    end
  end

  def destroy
    sign_out!
    redirect_to login_url
  end

  # maybe get rid of this and just replace with '/auth/linkeidn' in button where its called refactor, also maybe move all of these to user controller
  def new_linkedin
    redirect_to '/auth/linkedin'
  end

  def existing_linkedin
    @@existing = true
    redirect_to '/auth/linkedin'
  end

  def add_linkedin
    @@add = true
    redirect_to '/auth/linkedin'
  end

  def update_linkedin
    @@update = true
    redirect_to '/auth/linkedin'
  end

  def delete_linkedin
    current_user.linkedin.destroy
    current_user.update(
      provider: "",
      uid: "",
      location: ""
    )
    redirect_to :back
  end

  def create_linkedin
    # maybe refactor because of inability to display errors with adding and updating
    if @@add
      current_user.add_with_omniauth(auth_hash)
      flash[:success] = "Linkedin added to profile"
      @@add = false
      redirect_to :back and return
    end
    if @@update
      current_user.update_with_omniauth(auth_hash)
      flash[:success] = "Linkedin information updated"
      @@update = false
      redirect_to :back and return
    end

    @user = User.where(:provider => auth_hash['provider'],
                      :uid => auth_hash['uid'].to_s).first
    # need to refactor later, some repeat code
    if !@user && User.where(:email => auth_hash['info']['email']).first # register or sign in with Linkedin and email taken without Linkedin integration
      flash[:error] = "User with this email already exists, please log in and add Linkedin to your profile"
      redirect_to :back and return
    elsif !@user && !@@existing # register with linkedin and no linkedin account
      @user = User.create_with_omniauth(auth_hash)
      flash[:success] = "Welcome to smartXchange. Please complete your profile!"
      @@existing = false
      sign_in!(@user)
      redirect_to user_url(@user) and return
    elsif @user && !@@existing # register with linkedin and linkedin account
      flash[:error] = "Linkedin account already registered with smartXchange"
      redirect_to login_url and return
    elsif !@user && @@existing # sign in with Linkedin and no Linkedin account
      flash[:error] = "No Linkedin account registered with smartXchange, please register"
      @@existing = false
      redirect_to signup_url and return
    end # @user && @@existing, sign in with linkedin and account exists
    @@existing = false
    sign_in!(@user)
    redirect_to users_url
  end

  protected

  def auth_hash
    # maybe add something here about returning if no auth_hash
    request.env['omniauth.auth']
  end

end
