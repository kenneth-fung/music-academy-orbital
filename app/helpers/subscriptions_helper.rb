module SubscriptionsHelper

  # Returns a subscription (or nil) for a given student and course
  def find_subscription(student, course)
    student.subscriptions.find_by(course_id: course.id) if student.class == Student
  end

end
