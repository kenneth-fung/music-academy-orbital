require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @student       = students(:michael)
    @other_student = students(:archer)
  end

  test "should redirect index when not logged in" do
    get students_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when not logged in" do
    get edit_student_path(@student)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect edit when logged in as wrong student" do
    log_in_as(@other_student)
    get edit_student_path(@student)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong student" do
    log_in_as(@other_student)
    patch student_path(@student), params: { student: { name: @student.name,
                                                       email: @student.email } }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Student.count' do
      delete student_path(@student)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_student)
    assert_no_difference 'Student.count' do
      delete student_path(@student)
    end
    assert_redirected_to root_url
  end
end
