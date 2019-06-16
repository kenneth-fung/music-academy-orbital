require 'test_helper'

class StudentsLoginTest < ActionDispatch::IntegrationTest
  def setup
    @student = students(:michael)
  end

  test "login with valid information" do
    get student_login_path
    post student_login_path, params: { session: { email:    @student.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @student
    follow_redirect!
    assert_template 'students/show'
    assert_select "a[href=?]", student_login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", student_path(@student)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", student_login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", student_path(@student), count: 0
  end

  test "login with remembering" do
    log_in_as(@student, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test "login without remembering" do
    # Log in to set the cookie.
    log_in_as(@student, remember_me: '1')
    # Log in again and verify that the cookie is deleted.
    log_in_as(@student, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
