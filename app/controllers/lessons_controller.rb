class LessonsController < ApplicationController
  before_action :find_lesson_and_course, only: [:edit, :destroy, :delete_video, :delete_resource]
  before_action :is_course_tutor?, only: [:new, :create, :edit, :update, :destroy, :delete_video, :delete_resource]

  def new
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.new
  end

  def create
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.build(lesson_params)
    if @lesson.save
      flash[:success] = "Lesson: '#{@lesson.name}' for '#{@course.title}' has been published."
      redirect_to @course
    else
      render 'lessons/new'
    end
  end

  def show
    @lesson = Lesson.find(params[:id])
    @course = Course.find(@lesson.course_id)
    redirect_to @course
  end

  def index
    redirect_to root_path
  end

  def edit
  end

  def update
    @course = Course.find(params[:course_id])
    @lesson = Lesson.find(params[:id])
    if @lesson.update_attributes(lesson_params)
      flash[:success] = "Lesson: '#{@lesson.name}' edited."
      redirect_to @course
    else
      render 'edit'
    end
  end

  def destroy
    if params[:_method] == 'delete'
      @lesson.destroy
      flash[:success] = "Lesson deleted."
      redirect_to @course
    end
  end

  def delete_video
    video = ActiveStorage::Attachment.find(params[:id])
    video.purge
    redirect_to edit_lesson_path(
      @lesson, 
      lesson_id: @lesson.id, 
      course_id: @course.id
    )
  end

  def delete_resource
    resource = ActiveStorage::Attachment.find(params[:id])
    resource.purge
    redirect_to edit_lesson_path(
      @lesson, 
      lesson_id: @lesson.id, 
      course_id: @course.id
    )
  end

  private

  def find_lesson_and_course
    @lesson = Lesson.find(params[:lesson_id])
    @course = Course.find(@lesson.course_id)
  end
  
  # Confirms the current user is the tutor of this course
  def is_course_tutor?
    course = @course || Course.find(params[:course_id])
    unless tutor? && current_user.email == course.tutor.email
      redirect_to course_path(course)
    end
  end

  def lesson_params
    params.require(:lesson).permit(:video, :name, :description, resources: [])
  end

end
