class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  #before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    if params[:user_type] == Tutor.name
      @user = Tutor.find_by(email: params[:password_reset][:email].downcase)
    else
      @user = Student.find_by(email: params[:password_reset][:email].downcase)
    end
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user_type] == Tutor.name
      if params[:tutor][:password].empty?                  # Case (3)
        @user.errors.add(:password, "can't be empty")
        render 'edit'
      elsif @user.update_attributes(tutor_params)          # Case (4)
        log_in @user
        flash[:success] = "Password has been reset."
        redirect_to @user
      else
        render 'edit'                                     # Case (2)
      end
    else
      if params[:student][:password].empty?                  # Case (3)
        @user.errors.add(:password, "can't be empty")
        render 'edit'
      elsif @user.update_attributes(student_params)          # Case (4)
        log_in @user
        flash[:success] = "Password has been reset."
        redirect_to @user
      else
        render 'edit'                                     # Case (2)
      end
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
    if params[:user_type] == "Student"
      @user = Student.find_by(email: params[:email])
    else
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
