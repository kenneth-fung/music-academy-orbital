require 'test_helper'

class StudentsEditTest < ActionDispatch::IntegrationTest
  def setup
    @student = students(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@student)
    get edit_student_path(@student)
    assert_template 'students/edit'
    patch student_path(@student), params: { student: { name:  "",
                                                       email: "foo@invalid",
                                                       password:              "foo",
                                                       password_confirmation: "bar" } }

    assert_template 'students/edit'
    assert_select "div.alert", "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_student_path(@student)
    log_in_as(@student)
    assert_redirected_to edit_student_url(@student)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch student_path(@student), params: { student: { name:  name,
                                                       email: email,
                                                       password:              "password",
                                                       password_confirmation: "password" } }
  end

  test "successful edit" do
    log_in_as @student
    get edit_student_path(@student)
    assert_template 'students/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch student_path(@student), params: { student: { name:  name,
                                                       email: email,
                                                       password:              "",
                                                       password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to edit_student_path(@student)
    @student.reload
    assert_equal name,  @student.name
    assert_equal email, @student.email
  end
end
