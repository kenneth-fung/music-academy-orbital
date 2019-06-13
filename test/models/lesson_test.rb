require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  def setup
    @course = courses(:piano)
    @lesson = Lesson.new(name: 'Example Lesson',
                         description: 'This is an example of a lesson.',
                         course_id: @course.id)
  end

  test "should be valid" do
    assert @lesson.valid?
  end

  test "course id should be present" do
    @lesson.course_id = nil
    assert_not @lesson.valid?
  end

  test "name should be present" do
    @lesson.name = "    "
    assert_not @lesson.valid?
  end

  test "name should be at most 50 characters" do
    @lesson.name = 'a' * 51
    assert_not @lesson.valid?
  end

  test "description should be present" do
    @lesson.description = "    "
    assert_not @lesson.valid?
  end
end
