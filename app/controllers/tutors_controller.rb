class TutorsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @tutors = Tutor.where(activated: true).paginate(page: params[:page])
  end

  def new
    @tutor = Tutor.new
  end

  def create
    @tutor = Tutor.new(tutor_params)
    if @tutor.save
      @tutor.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
    redirect_to root_url and return unless @tutor.activated?
  end

  def edit
    @tutor = Tutor.find(params[:id])
  end

  def update
    @tutor = Tutor.find(params[:id])
    if @tutor.update_attributes(tutor_params)
      flash[:success] = "Changes saved!"
      redirect_to @tutor
    else
      render 'edit'
    end
  end

  def destroy
    Tutor.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to tutors_url
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
end
