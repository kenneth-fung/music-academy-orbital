require 'test_helper'

class NotificationTest < ActiveSupport::TestCase

  def setup
    @student = students(:michael)
    @notification = Notification.create(content: 'Lorem', 
                                        read: false, 
                                        user_id: @student.id, 
                                        user_type: 'Student')
  end

  test "should be valid" do
    assert @notification.valid?
  end

  test "content should be present" do
    @notification.content = nil
    assert_not @notification.valid?
  end

  test "content should be at most 200 in length" do
    @notification.content = 'a' * 201
    assert_not @notification.valid?
  end

  test "user_id should be present" do
    @notification.user_id = nil
    assert_not @notification.valid?
  end

  test "user_id should be a number" do
    @notification.user_id = 'foobar'
    assert_not @notification.valid?
  end

  test "user_type should be present" do
    @notification.user_type = nil
    assert_not @notification.valid?
  end

end
