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
    if lesson.posts.any?
      lesson.posts.each do |post|

        result += 1 unless post.read

        if post.messages.any?
          post.messages.each {|message| result += 1 unless message.read }
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

  def clear_unread(lesson)
    if lesson.posts.any?
      lesson.posts.each do |post|
        post.update_attribute(:read, true)
        if post.messages.any?
          post.messages.each {|message| message.update_attribute(:read, true)}
        end
      end
    end
  end

end
