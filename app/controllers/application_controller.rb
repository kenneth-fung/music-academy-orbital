class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  # Confirms a logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to root_url
    end
  end

  # Confirms a correct user
  def correct_user
    if session[:student_id]
      @user = Student.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    else
      @user = Tutor.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
