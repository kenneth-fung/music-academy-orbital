require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup 
    @tutor = tutors(:michael)
    @course = Course.new(title: 'Example Course',
                         content: 'This is an example of a course.',
                         price: 9.99,
                         tutor: @tutor)
  end

  test "should be valid" do
    assert @course.valid?
  end

  test "title should be present" do
    @course.title = "    "
    assert_not @course.valid?
  end

  test "title should be at most 50 characters" do
    @course.title = 'a' * 51
    assert_not @course.valid?
  end

  test "content should be present" do
    @course.content = "    "
    assert_not @course.valid?
  end

  test "price should be present" do
    @course.price = "    "
    assert_not @course.valid?
  end

  test "price should be a number" do
    @course.price = "foobar"
    assert_not @course.valid?
  end

  test "price should be at least 0.00" do
    @course.price = -1
    assert_not @course.valid?
  end

  test "tutor should be present" do
    @course.tutor = nil
    assert_not @course.valid?
  end

  test "associated lessons should be destroyed" do
    @course.save
    @course.lessons.create!(name: 'Lorem ipsum',
                            description: 'Lorem ipsum')
    assert_difference 'Lesson.count', -1 do
      @course.destroy
    end
  end

  test "associated reviews should be destroyed" do
    @course.save
    @course.reviews.create!(rating: 3, 
                            content: 'Lorem', 
                            student_id: students(:michael).id)
    assert_difference 'Review.count', -1 do
      @course.destroy
    end
  end

end
