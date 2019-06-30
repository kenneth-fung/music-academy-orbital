class PostsController < ApplicationController
  def create
    @lesson = Lesson.find(params[:lesson_id])
    @course = Course.find(params[:course_id])
    @post = @lesson.posts.new(post_params)
    if @post.save
      redirect_to course_path(@course, lesson_page: @lesson.position, anchor: 'forum')
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
