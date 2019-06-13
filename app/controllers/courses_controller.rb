class CoursesController < ApplicationController
  before_action :is_tutor?, only: [:new, :create, :edit, :update, :destroy]

  def index
    @courses = Course.paginate(page: params[:page])
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

  end

  def show
    @course = Course.find(params[:id])
    @lessons = @course.lessons.paginate(page: params[:page], per_page: 1)
  end

  def destroy

  end

  private

  def is_tutor?
    if !current_user.nil?
      if current_user.class == Student.first.class
        flash[:danger] = "You are not authorized"
        redirect_to root_url
      end
    else
      flash[:danger] = "Please log in"
      redirect_to root_url
    end
  end

  def course_params
    params.require(:course).permit(:title, :content, :image)
  end
end
