require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  def setup
    @student = students(:michael)
    @course = courses(:piano)
    @review = @student.reviews.build(rating: 3, content: 'Lorem ipsum', course_id: @course.id)
  end

  test "should be valid" do
    assert @review.valid?
  end

  test "student id should be present" do
    @review.student_id = nil
    assert_not @review.valid?
  end
  
  test "course id should be present" do
    @review.course_id = nil
    assert_not @review.valid?
  end

  test "rating should be present" do
    @review.rating = nil
    assert_not @review.valid?
  end

  test "rating should be a number" do
    @review.rating = 'foobar'
    assert_not @review.valid?
  end

  test "rating should be an integer" do
    @review.rating = 2.5
    assert_not @review.valid?
  end

  test "rating should be at least 1" do
    @review.rating = 0
    assert_not @review.valid?
  end

  test "rating should be at most 5" do
    @review.rating = 6
    assert_not @review.valid?
  end

  test "content should be present" do
    @review.content = nil
    assert_not @review.valid?
  end

end
