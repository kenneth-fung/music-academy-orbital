class LessonsController < ApplicationController
  before_action :is_course_tutor?

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

  def edit
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.find(params[:lesson_id])
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
    @course = Course.find(params[:course_id])
    @lesson = Lesson.find(params[:lesson_id])
    unless params[:_method].nil?
      @lesson.destroy
      flash[:success] = "Lesson deleted."
      redirect_to @course
    end
  end

  private
  
  # Confirms the current user is the tutor of this course
  def is_course_tutor?
    course = Course.find(params[:course_id])
    unless tutor? && current_user.email == course.tutor.email
      redirect_to course_path(course)
    end
  end

  def lesson_params
    params.require(:lesson).permit(:video, :name, :description)
  end

end
