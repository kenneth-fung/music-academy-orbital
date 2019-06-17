class SessionsController < ApplicationController
  before_action :is_logged_out?, only: [:new_student, :new_tutor, :create_student, :create_tutor]
  before_action :is_logged_in?, only: [:destroy]

  def new_student
  end

  def new_tutor
  end

  def create_student
    @student = Student.find_by(email: params[:session][:email].downcase)
    if @student && @student.authenticate(params[:session][:password])
      if @student.activated?
        log_in @student
        params[:session][:remember_me] == '1' ? remember(@student) : forget(@student)
        redirect_back_or @student
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination."
      render 'new_student'
    end
  end

  def create_tutor
    @tutor = Tutor.find_by(email: params[:session][:email].downcase)
    if @tutor && @tutor.authenticate(params[:session][:password])
      if @tutor.activated?
        log_in @tutor
        params[:session][:remember_me] == '1' ? remember(@tutor) : forget(@tutor)
        redirect_back_or @tutor
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination."
      render 'new_tutor'
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
