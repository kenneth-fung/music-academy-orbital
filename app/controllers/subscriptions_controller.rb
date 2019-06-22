class SubscriptionsController < ApplicationController
  before_action :logged_in_user
  before_action :unsubscribed?, only: [:new, :create]

  def new
    @course = Course.find(params[:course_id])
  end

  def create
    @course = Course.find(params[:course_id])
    current_user.subscribe(@course)
    redirect_to @course
  end

  def destroy
    @course = Course.find(params[:course_id])
    unless params[:_method].nil?
      current_user.unsubscribe(@course)
      redirect_to @course
    end
  end

  private

  # Before filters

  # Confirms that the user has not subscribed to this course already
  def unsubscribed?
    @user = current_user
    @course = Course.find(params[:course_id])
    if subscribing?(@course)
      flash[:danger] = "You have already subscribed to this course."
      redirect_to @course
    end
  end
end
