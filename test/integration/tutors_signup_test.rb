require 'test_helper'

class TutorsSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information tutor" do
    get tutor_signup_path
    assert_no_difference 'Tutor.count' do
      post tutor_signup_path, params: { tutor: { name:  "",
                                               email: "user@invalid",
                                               password:              "foo",
                                               password_confirmation: "bar" } }
    end
    assert_template 'tutors/new'
  end

  test "valid signup information with account activation" do
    get tutor_signup_path
    assert_difference 'Tutor.count', 1 do
      post tutor_signup_path, params: { tutor: { name:  "Example User",
                                                     email: "user@example.com",
                                                     password:              "password",
                                                     password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:tutor)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert is_logged_in?
  end
end
