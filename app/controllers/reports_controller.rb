class ReportsController < ApplicationController
  before_action :logged_in_user, only: :create

  def create
    if report_params[:details].blank?
      message = "Report cannot be blank. Please fill in the required details."
      flash[:danger] = message
    else
      generate_notifications
      flash[:success] = "Your report has been sent and will be processed."
    end
    redirect_back fallback_location: root_path
  end

  private

  def report_params
    params.require(:report).permit(:title, :details, :origin_type, :origin_id)
  end

  def generate_notifications
    content = "<#{report_params[:title]}> #{report_params[:details]}"
    origin_type = report_params[:origin_type]
    origin_id = report_params[:origin_id]
    Student.where(admin: true).find_each do |admin|
      Notification.create(content: content,
                          user_type: admin.class.name,
                          user_id: admin.id,
                          origin_type: origin_type,
                          origin_id: origin_id)
    end
    Tutor.where(admin: true).find_each do |admin|
      Notification.create(content: content,
                          user_type: admin.class.name,
                          user_id: admin.id,
                          origin_type: origin_type,
                          origin_id: origin_id)
    end
  end

end
