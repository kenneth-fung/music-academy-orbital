ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:student_id].nil? || !session[:tutor_id].nil?
  end

  def log_in_as(user)
    if user.class == Tutor
      session[tutor_id] = user.id
    elsif user.class == Student
      session[student_id] = user.id
    end
  end
end

class ActionDispatch::IntegrationTest

  # Log in as a particular user.
  def log_in_as(user, password: 'password', remember_me: '0')
    post login_path, params: { session: { user_type: user.class.to_s,
                                          email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
