class ReviewsController < ApplicationController
  before_action :logged_in_user,  only: [:create, :destroy]
  before_action :subscribed_user, only: [:create, :destroy]
  before_action :no_review_yet,   only: :create
  before_action :review_poster,   only: :destroy

  def create
    @review = current_user.reviews.build(review_params)
    if @review.update_attributes(course_id: params[:course_id])
      @course.update_attributes(rating: @course.reviews.average(:rating).ceil)
      flash[:success] = "Review posted!"
      redirect_to @course
    else
      @lessons = @course.lessons.reorder(:position)
      @lesson = @lessons[0]
      @reviews = @course.reviews.paginate(page: params[:page])
      render 'courses/show'
    end
  end

  def index
    redirect_to current_user
  end

  def destroy
    @review.destroy
    flash[:success] = "Review deleted."
    redirect_to @course
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end

  # Before filters

  # Confirms that the current user is subscribed to the course
  def subscribed_user
    @course = Course.find(params[:course_id])
    unless subscribing?(@course)
      redirect_to @course
      flash[:danger] = "You must be subscribed to a course to post and delete a review."
    end
  end

  # Confirms that the current user has not posted any review for this course
  def no_review_yet
    if current_user.review_for(@course)
      flash[:danger] = "You can only post one review per course."
      redirect_to @course
    end
  end

  # Confirms that the current user is the poster of a review
  def review_poster
    @review = current_user.reviews.find_by(course_id: @course.id)
    redirect_to @course if @review.nil?
  end

end
