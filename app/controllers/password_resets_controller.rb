class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    user_type = params[:password_reset][:user_type].constantize
    @user = user_type.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Please check your email to reset your password."
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found."
      render 'new'
    end
  end

  def edit
  end

  def update
    type = params[:user_type].downcase.to_sym
    if params[type][:password].empty?
      # Case: Failed update due to empty password and confirmation
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(send("#{type}_params"))
      # Case: Successful update
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Your password has been reset."
      redirect_to @user
    else
      # Case: Failed update due to invalid password
      render 'edit'
    end
  end

  private

  def student_params
    params.require(:student).permit(:password, :password_confirmation)
  end

  def tutor_params
    params.require(:tutor).permit(:password, :password_confirmation)
  end

  def get_user
    if params[:user_type] == Student.name
      @user = Student.find_by(email: params[:email])
    elsif params[:user_type] == Tutor.name
      @user = Tutor.find_by(email: params[:email])
    end
  end

  # Confirms a valid user.
  def valid_user
    unless (@user && @user.activated? &&
            authenticated?(:reset, params[:id], @user))
      redirect_to root_url
    end
  end

  # Checks expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_path
    end
  end
end
