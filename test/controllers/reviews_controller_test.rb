require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @review = reviews(:one)
    @course = courses(:piano)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Review.count' do
      post reviews_path, params: { review: { rating: 3, 
                                             content: 'Lorem', 
                                             course_id: @course.id } }
    end
    assert_redirected_to login_path(user_type: "Student")
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Review.count' do
      delete review_path(@review)
    end
    assert_redirected_to login_path(user_type: "Student")
  end

end
