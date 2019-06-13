class SessionsController < ApplicationController
  def new_student
  end

  def new_tutor
  end

  def create_student
    @student = Student.find_by(email: params[:session][:email].downcase)
    if @student && @student.authenticate(params[:session][:password])
      log_in_student @student
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to @student
    else
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new_student'
    end
  end

  def create_tutor
    @tutor = Tutor.find_by(email: params[:session][:email].downcase)
    if @tutor && @tutor.authenticate(params[:session][:password])
      log_in_tutor @tutor
      remember @tutor
      redirect_to @tutor
    else
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new_tutor'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
