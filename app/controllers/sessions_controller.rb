class SessionsController < ApplicationController
  before_action :is_logged_out?, only: [:new, :create]
  before_action :is_logged_in?,  only: [:destroy]

  def new
  end

  def create
    user_type = params[:session][:user_type].constantize
    @user = user_type.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        if @user.instance_of?(Tutor)
          message = find_total_unread(@user) == 1 ? 'message' : 'messages'
          flash[:success] = "You have #{find_total_unread(@user)} #{message}!"
        end
        redirect_back_or @user
      else
        message = "Account not activated."
        message += "Please check your email for the activation link."
        flash[:warning] = message
        redirect_to root_path
      end
    else
      flash.now[:danger] = "Invalid email/password combination."
      render 'new'
    end
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
