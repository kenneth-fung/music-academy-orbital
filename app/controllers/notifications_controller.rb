class NotificationsController < ApplicationController
  before_action :logged_in_user,         only: [:destroy, :clear]
  before_action :notification_recipient, only: :destroy

  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: current_user }
      format.js
    end
  end

  def clear
    Notification.where(user_type: current_user.class.name, user_id: current_user.id).destroy_all
    respond_to do |format|
      format.html { redirect_back fallback_location: current_user }
      format.js
    end
  end

  private

  # Before filters

  # Confirms that the current user is the recipient of the notification
  def notification_recipient
    @notification = Notification.find(params[:notification_id])
    unless current_user?(@notification.user_type.constantize.find(@notification.user_id))
      redirect_to current_user
    end
  end

end
