class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @course = Course.find(params[:course_id])
    @post = @lesson.posts.new(post_params)
    if @post.save
      @post.update_attributes(user_id: current_user.id, user_type: current_user.class.name)
      clear_unread(@lesson) if current_user?(@course.tutor)
    end
    redirect_to course_path(@course, lesson_page: @lesson.position, anchor: 'forum')
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
