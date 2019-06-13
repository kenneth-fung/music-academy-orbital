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
    if user.class.name == Tutor.name
      session[tutor_id] = user.id
    elsif
      session[student_id] = user.id
    end
  end
end
