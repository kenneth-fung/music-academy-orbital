module ApplicationHelper
  def full_title(title)
    base_title = "Music Academy"
    if title.empty?
      base_title
    else
      "#{title} | #{base_title}"
    end
  end

  def find_left_off(student, course)
    subscription = Subscription.where("student_id = ? AND course_id = ?", student.id, course.id).first
    if subscription
      return subscription
    else
      return nil
    end
  end
end
