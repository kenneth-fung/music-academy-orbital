module LessonsHelper

  def find_unread_from_course(course)
    result = 0
    if course.lessons.any?
      course.lessons.each {|lesson| result += find_unread_from_lesson(lesson) }
    end
    return result
  end

  def find_unread_from_lesson(lesson)
    result = 0
    notification_query = "user_type = ? AND user_id = ? AND origin_type = ? AND origin_id = ? AND read = ?"

    if lesson.posts.any?

      lesson.posts.each do |post|

        result += Notification.where(notification_query, 'Tutor', current_user.id, 'Post', post.id, false).count

        if post.messages.any?
          post.messages.each do |message|
            result += Notification.where(notification_query, 'Tutor', current_user.id, 'Message', message.id, false).count
          end
        end

      end
    end
    return result
  end

  def find_total_unread(tutor)
    result = 0
    if tutor.courses.any?
      tutor.courses.each {|course| result += find_unread_from_course(course) }
    end
    return result
  end

end
