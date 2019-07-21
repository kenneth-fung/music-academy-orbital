class SessionsController < ApplicationController
  before_action :is_logged_out?, only: [:new, :create]
  before_action :is_logged_in?,  only: [:destroy]

  def new
    if params[:user_type].nil?
      params[:user_type] = 'Student'
    end
  end

  def create
    user_type = params[:session][:user_type].constantize
    @user = user_type.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        if user_type == Tutor
          redirect_back_or @user
        elsif user_type == Student
          redirect_back_or root_path
        end
      else
        params[:user_type] = params[:session][:user_type]
        params[:error] = 'unactivated'
        render 'new'
      end
    elsif @user && !@user.provider.nil?
      params[:user_type] = params[:session][:user_type]
      params[:error] = 'provider account'
      render 'new'
    else
      params[:user_type] = params[:session][:user_type]
      params[:error] = 'email/password'
      render 'new'
    end
  end

  def create_with_auth
    params = request.env["omniauth.params"]

    if params["user_type"] == 'Student'

      @user = Student.find_from_auth_hash(request.env["omniauth.auth"])
      method = 'logged in'
      if @user.nil?
        @user = Student.create_from_auth_hash(request.env["omniauth.auth"])
        method = 'signed up'
      end

    elsif params["user_type"] == 'Tutor'

      @user = Tutor.find_from_auth_hash(request.env["omniauth.auth"])
      method = 'logged in'
      if @user.nil?
        @user = Tutor.create_from_auth_hash(request.env["omniauth.auth"])
        method = 'signed up'
      end

    end

    flash[:success] = "Successfully #{method} through Google!"
    log_in @user
    redirect_back_or @user
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private 

  # Before filters

  # Confirms that the user is logged in
  def is_logged_in?
    if logged_out?
      flash[:danger] = "You are not logged in."
      redirect_to root_path
    end
  end

  # Confirms that the user is logged out
  def is_logged_out?
    if logged_in?
      flash[:danger] = "You have already logged in."
      redirect_to root_path
    end
  end
end
