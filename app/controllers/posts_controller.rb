class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :post_sender,    only: :destroy

  def create
    @lesson = Lesson.find(params[:lesson_id])
    @course = Course.find(params[:course_id])
    @post = @lesson.posts.new(post_params)
    if @post.save
      @post.update_attributes(user_id: current_user.id, user_type: current_user.class.name)
      generate_notification unless @post.sender == @course.tutor
      clear_unread(@lesson) if current_user?(@course.tutor)
    end
    back_to_course
  end

  def destroy
    @post.destroy
    back_to_course
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def back_to_course
    redirect_to course_path(@course, lesson_page: @lesson.position, anchor: 'forum')
  end

  def generate_notification
    notification = "New Question about '#{@lesson.name}' for '#{@course.title}'"
    Notification.create(content: notification, 
                        user_id: @course.tutor.id, 
                        user_type: 'Tutor', 
                        origin_type: 'Post', 
                        origin_id: @post.id)
  end

  # Before filters
  
  def post_sender
    @post = Post.find(params[:id])
    @lesson = @post.lesson
    @course = @lesson.course
    back_to_course unless current_user?(@post.sender)
  end

end
