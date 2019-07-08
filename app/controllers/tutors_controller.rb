class TutorsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :is_logged_out?, only: [:new, :create]
  before_action :delete_notifications, only: :destroy

  def new
    @tutor = Tutor.new
    @student = Student.new
  end

  def create
    @tutor = Tutor.new(tutor_params)
    if @tutor.save
      @tutor.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      @student = Student.new
      render 'new'
    end
  end

  def show
    @tutor = Tutor.find(params[:id])
    @courses = @tutor.courses.reorder(created_at: :desc)
    @title = tutor? && current_user?(@tutor) ?
      'My Profile' :
      "#{@tutor.name}'s Profile"

    @notifications = @tutor
    .notifications
    .reorder(created_at: :desc) if current_user? @tutor

    if params[:mark_read]
      Notification.find(params[:mark_read]).update_attribute(:read, true)
    end

    redirect_to root_path and return unless @tutor.activated?
  end

  def index
    @tutors = Tutor.where(activated: true).paginate(page: params[:page])
    @title = "All Tutors"
  end

  def students
    @tutor = Tutor.find(params[:id])
    @students = @tutor.students_unique.where(activated: true).paginate(page: params[:page])
    @title = (tutor? && current_user?(@tutor)) ? 
      "My Students" : 
      "#{@tutor.name}'s Students"
    render 'students/index'
  end

  def courses
    @tutor = Tutor.find(params[:id])
    @courses = @tutor.courses.reorder(created_at: :desc).paginate(page: params[:page])
    @title = (tutor? && current_user?(@tutor)) ?
      "My Courses" :
      "#{@tutor.name}'s Courses"
  end

  def edit
    @tutor = Tutor.find(params[:id])
  end

  def update
    @tutor = Tutor.find(params[:id])
    if @tutor.update_attributes(tutor_params)
      flash[:success] = "Changes saved!"
      redirect_to edit_tutor_path(@tutor)
    else
      render 'edit'
    end
  end

  def destroy
    @tutor.destroy
    flash[:success] = "User deleted"
    redirect_to tutors_url
  end

  private

  def tutor_params
    params.require(:tutor).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms that the user is logged out
  def is_logged_out?
    if logged_in?
      flash[:danger] = "Please log out first."
      redirect_to root_path
    end
  end

  # Deletes the notifications created for this tutor
  def delete_notifications
    @tutor = Tutor.find(params[:id])
    Notification.where(user_type: 'Tutor', user_id: @tutor.id).destroy_all
  end

end
