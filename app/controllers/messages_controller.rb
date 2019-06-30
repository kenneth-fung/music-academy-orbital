class MessagesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @lesson = Lesson.find(params[:lesson_id])
    @message = @post.messages.build(message_params)
    @course = Course.find(params[:course_id])
    if @message.save
      @message.update_attributes(user_id: current_user.id, user_type: current_user.class.name)
      redirect_to course_path(@course, lesson_page: @lesson.position, anchor: 'forum')
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
