require 'test_helper'

class TutorsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @tutor       = tutors(:michael)
    @other_tutor = tutors(:archer)
  end

  test "should redirect index when not logged in" do
    get tutors_path
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get edit_tutor_path(@tutor)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as wrong tutor" do
    log_in_as(@other_tutor)
    get edit_tutor_path(@tutor)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong tutor" do
    log_in_as(@other_tutor)
    patch tutor_path(@tutor), params: { tutor: { name: @tutor.name,
                                              email: @tutor.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Tutor.count' do
      delete tutor_path(@tutor)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_tutor)
    assert_no_difference 'Tutor.count' do
      delete tutor_path(@tutor)
    end
    assert_redirected_to root_url
  end
end
