class StudentsController < ApplicationController
  before_action :is_logged_in?, only: [:edit, :update]
  before_action :is_logged_out?, only: [:new, :create]

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
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(student_params)
      flash[:success] = "Changes savedd."
      redirect_to @student
    else
      render 'edit'
    end
  end

  def destroy
  end

  def courses
    @student = Student.find(params[:id])
    @courses = @student.courses.paginate(page: params[:page])
    render 'students/show_enrolled'
  end

  private

  def student_params
    params.require(:student).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms that the user is logged in
  def is_logged_in?
    if logged_out?
      flash[:danger] = "Please log in."
      redirect_to student_login_path
    end
  end

  # Confirms that the user is logged out
  def is_logged_out?
    if logged_in?
      flash[:danger] = "Please log out first."
      redirect_to root_path
    end
  end

end
