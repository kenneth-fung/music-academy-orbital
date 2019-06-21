class CoursesController < ApplicationController
  before_action :is_tutor?,        only: [:new, :create, :edit, :update, :destroy]
  before_action :is_course_owner?, only: [:edit, :update, :destroy, :delete_image]

  def index
    if params[:search]
      @title = "Search: \"#{params[:search]}\""
      @courses = Course.search("#{params[:search]}").paginate(page: params[:page])
    else
      @title = "All Courses"
      @courses = Course.paginate(page: params[:page])
    end
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
      render 'edit'
    end
  end

  def show
    @course = Course.find(params[:id])
    @lessons = @course.lessons.paginate(page: params[:page], per_page: 1)
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
    params.require(:course).permit(:title, :content, :price, :image, :search)
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
  def is_course_owner?
    @course = Course.find(params[:course_id])
    unless tutor? && current_user?(@course.tutor)
      flash[:danger] = "You are not the owner of this course."
      redirect_to root_path
    end
  end

end
