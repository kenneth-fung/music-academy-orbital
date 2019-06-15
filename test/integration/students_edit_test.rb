require 'test_helper'

class StudentsEditTest < ActionDispatch::IntegrationTest
  def setup
    @student = students(:runding)
  end

  test "unsuccessful edit" do
    log_in_as @student
    get edit_student_path(@student)
    assert_template 'students/edit'
    patch student_path(@student), params: { student: { name:  "",
                                                       email: "foo@invalid",
                                                       password:              "foo",
                                                       password_confirmation: "bar" } }

    assert_template 'students/edit'
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
    assert_redirected_to @student
    @student.reload
    assert_equal name,  @student.name
    assert_equal email, @student.email
  end
end
