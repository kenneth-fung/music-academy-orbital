class TutorsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
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

    courses = params[:search_profile] && !params[:search_profile].empty? ?
      @tutor.courses.search_title(params[:search_profile]) :
      @tutor.courses
    @courses = courses.sort_tutor_courses(params[:sort_by])

    @title = tutor? && current_user?(@tutor) ?
      'My Profile' :
      "#{@tutor.name}"

    @notifications = @tutor
    .notifications
    .reorder(created_at: :desc) if current_user? @tutor

    if params[:mark_read]
      Notification.find(params[:mark_read]).update_attribute(:read, true)
    end

    respond_to do |format|
      format.html { redirect_to root_path and return unless @tutor.activated? }
      format.js
    end
  end

  def index
    @title = "Tutors"

    popular_benchmark = Tutor.reorder(popularity: :asc).to_a[Tutor.count / 3 * 2].popularity
    @tutors_popular = Tutor.where(activated: true).where('popularity > ?', popular_benchmark).reorder(Arel.sql("RANDOM()")).limit(4)
    @tutors_guitar  = Tutor.where(activated: true).teaches('guitar').limit(4)
    @tutors_piano   = Tutor.where(activated: true).teaches('piano').limit(4)

    tutors  = Tutor.sort(params[:sort_by]).where(activated: true)

    respond_to do |format|
      format.html {
        tutors  = tutors.search(params[:search]) if params[:search]
        @tutors = tutors.paginate(page: params[:page], per_page: 12)
      }
      format.json {
        @tutors  = tutors.search(params[:search]) if params[:search]
      }
    end
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
    @courses = @tutor.courses
    @title = (tutor? && current_user?(@tutor)) ?
      "My Courses" :
      "#{@tutor.name}'s Courses"
    respond_to do |format|
      format.html {
        @courses = @courses.paginate(page: params[:page])
      }
      format.json {
        if params[:search_profile] && !params[:search_profile].blank?
          @courses = @courses.search_title(params[:search_profile]).limit(6)
        end
      }
    end
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
    params.require(:tutor).permit(:name, :email, :password, :password_confirmation, :qualification, :bio)
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
