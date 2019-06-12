class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      log_in_student @student
      flash[:success] = 'Successfully registered!'
      redirect_to @student
    else
      render 'new'
    end
  end

  def show
    @student = Student.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def courses
    @title = "Enrolled Courses"
    @courses = Student.find(params[:id]).courses.paginate(page: params[:page])
    render 'students/show_enrolled'
  end

  private

  def student_params
    params.require(:student).permit(:name, :email, :password, :password_confirmation)
  end
end
