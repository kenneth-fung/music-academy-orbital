class MessagesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :message_sender, only: :destroy

  before_action :delete_notifications, only: :destroy

  def create
    @post = Post.find(params[:post_id])
    @lesson = Lesson.find(params[:lesson_id])
    @message = @post.messages.build(message_params)
    @course = Course.find(params[:course_id])
    if @message.save
      @message.update_attributes(user_id: current_user.id, user_type: current_user.class.name)
      generate_notifications
      clear_unread(@lesson) if current_user?(@course.tutor)
    end
    back_to_course
  end

  def destroy
    @message.destroy
    back_to_course
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def back_to_course
    redirect_to course_path(@course, lesson_page: @lesson.position, anchor: 'forum')
  end

  def generate_notifications
    notification = "New Reply to '#{@post.content[0..20]}...'"
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
  def message_sender
    @message = Message.find(params[:id])
    @post = @message.post
    @lesson = @post.lesson
    @course = @lesson.course
    back_to_course unless current_user?(@message.sender)
  end

  # Deletes all the notifications created by this message
  def delete_notifications
    Notification.where(origin_type: 'Message', origin_id: @message.id).destroy_all
  end

end
