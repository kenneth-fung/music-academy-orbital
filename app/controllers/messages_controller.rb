class MessagesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :message_sender_or_admin, only: :destroy

  before_action :delete_notifications, only: :destroy

  after_action :update_course_unread, only: [:create, :destroy]

  def create
    @post = Post.find(params[:post_id])
    @lesson = Lesson.find(params[:lesson_id])
    @message = @post.messages.build(message_params)
    @course = Course.find(params[:course_id])
    if @message.save
      @message.update_attributes(user_id: current_user.id, user_type: current_user.class.name)
      read_notifications
      generate_notifications
    end
    respond_to do |format|
      format.html { back_to_course }
      format.js
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { back_to_course }
      format.js
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def back_to_course
    redirect_to course_path(@course, lesson_page: @lesson.position, anchor: 'forum')
  end

  # Marks all notifications from other messages in this message's post as read
  def read_notifications
    # Update post notification
    post_notification = @message.sender
    .notifications_unread
    .where("origin_type = ? AND origin_id = ?", 'Post', @post.id)
    .first
    post_notification.update_attributes(read: true) unless post_notification.nil?

    # Update post's messages notifications
    @post.messages.each do |message|
      message_notification = @message.sender
      .notifications_unread
      .where("origin_type = ? AND origin_id = ?", 'Message', message.id)
      .first
      message_notification.update_attributes(read: true) unless message_notification.nil?
    end
  end

  # Generates notifications for the post sender and senders of all other
  # messages in the post
  def generate_notifications
    notification = "New Reply to '#{@post.content}'"
    Notification.create(content: notification, 
                        user_id: @post.sender.id, 
                        user_type: @post.sender.class.name,
                        origin_type: 'Message',
                        origin_id: @message.id) unless @post.sender == @message.sender
    users = []
    @post.messages.each do |message|
      users << message.sender unless users.include?(message.sender) || @post.sender == message.sender
    end
    users.each do |user|
      Notification.create(content: notification,
                          user_id: user.id,
                          user_type: user.class.name,
                          origin_type: 'Message',
                          origin_id: @message.id) unless user == @message.sender
    end
  end

  # Before filters

  # Checks that the current user is the sender of the message
  def message_sender_or_admin
    @message = Message.find(params[:id])
    @post = @message.post
    @lesson = @post.lesson
    @course = @lesson.course
    back_to_course unless current_user?(@message.sender) or current_user.admin?
  end

  # Deletes all the notifications created by this message
  def delete_notifications
    Notification.where(origin_type: 'Message', origin_id: @message.id).destroy_all
  end

  # Updates the number of unread messages from the post's course
  def update_course_unread
    @course.update_attributes(unread: find_unread_from_course(@course))
  end

end
