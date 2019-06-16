class StudentsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @students = Student.where(activated: true).paginate(page: params[:page])
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      @student.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @student = Student.find(params[:id])
    redirect_to root_url and return unless @student.activated?
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(student_params)
      flash[:success] = "Changes saved!"
      redirect_to @student
    else
      render 'edit'
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to students_url
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
