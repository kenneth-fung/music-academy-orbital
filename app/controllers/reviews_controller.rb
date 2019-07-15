class ReviewsController < ApplicationController
  before_action :logged_in_user,  only: [:create, :destroy, :update]
  before_action :subscribed_user, only: [:create, :update]
  before_action :no_review_yet,   only: :create
  before_action :review_poster_or_admin,   only: [:destroy, :update]

  before_action :delete_notification, only: :destroy

  after_action :update_course_rating,     only: [:create, :destroy, :update]
  after_action :update_course_popularity, only: [:create, :destroy, :update]

  def create
    @review = current_user.reviews.build(review_params)
    if @review.update_attributes(course_id: params[:course_id])
      generate_notification
      flash[:success] = "Review posted!"
      redirect_to course_path(@course, anchor: "reviews")
    else
      @tutor = @course.tutor
      @lessons = @course.lessons.reorder(:position)
      @lesson = @lessons[0]
      @tags = @course.tags
      @reviews = @course.reviews.paginate(page: params[:page])
      render 'courses/show'
    end
  end

  def index
    redirect_to current_user
  end

  def update
    if @review.update_attributes(review_params)
      flash[:success] = "Changes saved!"
      redirect_to course_path(@course, anchor: "reviews")
    else
      @tutor = @course.tutor
      @lessons = @course.lessons.reorder(:position)
      @lesson = @lessons[0]
      @tags = @course.tags
      @reviews = @course.reviews.paginate(page: params[:page])
      params[:review_edit] = true
      render 'courses/show'
    end
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

  def generate_notification
    notification = "New Review for #{@course.title}"
    Notification.create(content: notification,
                        user_id: @course.tutor.id,
                        user_type: 'Tutor',
                        origin_type: 'Review',
                        origin_id: @review.id)
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
  def review_poster_or_admin
    if current_user.admin?
      @course = Course.find(params[:course_id])
      @review = Review.find(params[:review_id])
    else
      @course = Course.find(params[:course_id])
      @review = current_user.reviews.find_by(course_id: @course.id)
      redirect_to @course if @review.nil?
    end
  end

  # After filters

  # Updates the average rating of the course the review belongs to
  def update_course_rating
    @course.update_attributes(rating: @course.reviews.average(:rating).ceil)
  end

  # Updates the popularity of the course the review belongs to
  def update_course_popularity
    popularity = @course.reviews.count + @course.rating + @course.students.count
    @course.update_attributes(popularity: popularity)
  end

  # Deletes the notification created by this review
  def delete_notification
    Notification.where(origin_type: 'Review', origin_id: @review.id).destroy_all
  end

end
