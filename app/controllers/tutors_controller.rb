class TutorsController < ApplicationController
  before_action :is_logged_in?, only: [:edit, :update]
  before_action :is_logged_out?, only: [:new, :create]

  def new
    @tutor = Tutor.new
  end

  def create
    @tutor = Tutor.new(tutor_params)
    if @tutor.save
      log_in_tutor @tutor
      flash[:success] = 'Successfully registered!'
      redirect_to @tutor
    else
      render 'new'
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
  end

  def edit
  end

  def update

  end

  def destroy
  end

  def students
    @tutor = Tutor.find(params[:id])
    @students = @tutor.students_unique.paginate(page: params[:page])
    render 'tutors/show_students'
  end

  def courses
    @tutor = Tutor.find(params[:id])
    @courses = @tutor.courses.paginate(page: params[:page])
    render 'tutors/show_courses'
  end

  private

  def tutor_params
    params.require(:tutor).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms that the user is logged in
  def is_logged_in?
    if logged_out?
      flash[:danger] = "Please log in."
      redirect_to tutor_login_path
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
