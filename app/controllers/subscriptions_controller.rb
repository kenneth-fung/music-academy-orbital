class SubscriptionsController < ApplicationController
  before_action :logged_in_user
  before_action :unsubscribed?, only: [:new, :create]

  after_action :update_course_popularity, only: [:hook, :destroy]

  def create
    @course = Course.find(params[:course_id])
    current_user.subscribe(@course)
    current_user.update_attributes(pending_course: @course.id)
    redirect_to current_user.subscriptions.last.paypal_url(hook_path)
  end

  def hook
    # Payment completed, so erase pending course
    @course = Course.find_by(id: current_user.pending_course)
    current_user.update_attributes(pending_course: -1)
    flash[:success] = "You have enrolled for this course!"
    redirect_to course_path(@course, lesson_page: 1)
  end

  def destroy
    @course = Course.find(params[:course_id])
    unless params[:_method].nil?
      current_user.unsubscribe(@course)
      flash[:info] = "You have quit the course. Thank you for your patronage."
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

  # After filters

  # Updates the popularity of the course
  def update_course_popularity
    popularity = @course.reviews.count + @course.rating + @course.students.count
    @course.update_attributes(popularity: popularity)
  end

end
