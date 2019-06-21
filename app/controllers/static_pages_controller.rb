class StaticPagesController < ApplicationController
  def home
    @courses = Course.reorder("RANDOM()").limit(10)
    @title = 'Home'
    render 'courses/index'
  end

  def contact
  end

  def about
  end
end
