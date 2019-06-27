class MessagesController < ApplicationController
  def create
    @message = current_user.messages.build(message_params)
    @lesson = Lesson.find(params[:lesson_id])
    @course = Course.find(params[:course_id])
    @message.lessons << @lesson
    if @message.save
      respond_to do |format|
        format.html { redirect_to @course, lesson_page: @lesson.position }
        format.js
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
