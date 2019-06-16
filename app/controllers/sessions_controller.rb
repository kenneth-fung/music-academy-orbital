class SessionsController < ApplicationController
  before_action :is_logged_out?, only: [:new_student, :new_tutor, :create_student, :create_tutor]
  before_action :is_logged_in?, only: [:destroy]

  def new_student
  end

  def new_tutor
  end

  def create_student
    @user = Student.find_by(email: params[:session][:email].downcase)
    if @user.activated?
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      message  = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def create_tutor
    @user = Tutor.find_by(email: params[:session][:email].downcase)
    if @user.activated?
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      message  = "Account not activated. "
      message += "Check your email for the activation link."
      flash[:warning] = message
      redirect_to root_url
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
