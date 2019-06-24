class StaticPagesController < ApplicationController
  def home
    @courses = Course.reorder(Arel.sql("RANDOM()")).limit(10)
    @title = 'Home'
    render 'courses/index'
  end

  def signup
    @student = Student.new
    @tutor = Tutor.new
  end

  def contact
  end

  def about
  end
end
