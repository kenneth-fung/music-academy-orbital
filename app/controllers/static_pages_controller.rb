class StaticPagesController < ApplicationController
  def home
    @courses = Course.reorder(Arel.sql("RANDOM()")).limit(8)
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
