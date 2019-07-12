class CoursesController < ApplicationController
  before_action :is_tutor?,                 only: [:new, :create, :edit, :update, :destroy]
  before_action :is_course_tutor_or_admin?, only: [:edit, :update, :destroy, :delete_image]
  before_action :admin_user, only: :destroy

  def index
    courses = Course.sort(params[:sort_by])
    if params[:search]
      @title = "Search: \"#{params[:search]}\""
      courses = courses.search(params[:search])
    else
      @title = "Courses"
    end
    @courses = courses.paginate(page: params[:page])
  end

  def new
    @course = current_user.courses.new
  end

  def create
    @course = current_user.courses.build(course_params)
    if @course.save
      flash[:success] = "Successfully created"
      redirect_to @course
    else
      @course.image.purge
      render 'courses/new'
    end
  end

  def edit
  end

  def update
    if @course.update_attributes(course_params)
      flash[:success] = "Changes saved!"
      redirect_to edit_course_path(@course, course_id: @course.id)
    else
      @course.image.purge
      render 'edit'
    end
  end

  def show

    # Check if the current user student has a pending course, which means their
    # payment for this course failed
    if student? && current_user.pending_course != -1
      flash.now[:danger] = "You did not complete payment for this course."
      current_user.unsubscribe(Course.find_by(id: current_user.pending_course))
      current_user.update_attributes(pending_course: -1)
    end

    @course = Course.find(params[:id])
    @tutor = @course.tutor

    # Lessons
    position = 1
    if params[:lesson_page]
      position = params[:lesson_page]
    elsif subscribing?(@course)
      subscription = current_user.subscriptions.find_by(course_id: @course.id)
      position = subscription.left_off
    end
    @lessons = @course.lessons.reorder(:position)
    @lesson = @lessons[position.to_i - 1]

    @tags = @course.tags

    # Reviews
    if subscribing?(@course)
      current_user.review_for(@course).nil? ?
        @review = current_user.reviews.build :
        @curr_review = current_user.review_for(@course)
    end
    @reviews = Review
    .sort(params[:sort_by])
    .where(course_id: @course.id)

    # Notification updating
    if params[:notified_id]
      notification = Notification.find_by(id: params[:notified_id])
      notification.update_attribute(:read, true) unless notification.nil?
    end
  end

  def destroy
    @tutor = @course.tutor
    if params[:_method] == 'delete'
      @course.destroy
      flash[:success] = "Course deleted."
      redirect_to courses_tutor_path(@tutor)
    end
  end

  def delete_image
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to edit_course_path(@course, course_id: @course.id)
  end

  private

  def course_params
    params.require(:course).permit(:title, :content, :price, :image, :search, :tag_list)
  end

  # Before filters

  # Confirms that the current user is a tutor
  def is_tutor?
    unless tutor?
      if student?
        flash[:danger] = "You are not authorized to access this page."
      elsif logged_out?
        flash[:danger] = "Please log in."
      end
      redirect_to root_path
    end
  end

  # Confirms that the current user is the owner of this course
  def is_course_tutor_or_admin?
    @course = Course.find(params[:course_id])
    unless (tutor? && current_user?(@course.tutor)) || current_user.admin?
      flash[:danger] = "You are not the owner of this course."
      redirect_to root_path
    end
  end

end
