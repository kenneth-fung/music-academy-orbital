class AccountActivationsController < ApplicationController
  def edit
    user = Student.find_by(email: params[:email])
    if user && !user.activated?
    else
      user = Tutor.find_by(email: params[:email])
    end
    if user && !user.activated? && authenticated?(:activation, params[:id], user)
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
