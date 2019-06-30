module LessonsHelper
  def find_unread_from_course(course)
    result = 0
    if course.lessons
      course.lessons.each do |lesson|
        if lesson.posts
          lesson.posts.each do |post|
            if !post.read?
              result += 1
            end

            if post.messages
              post.messages.each do |message|
                unless message.read
                  result += 1
                end
              end
            end
          end
        end
      end
    end
    return result
  end

  def find_unread_from_lesson(lesson)
    result = 0
    if lesson.posts
      lesson.posts.each do |post|
        if !post.read?
          result += 1
        end

        if post.messages
          post.messages.each do |message|
            unless message.read
              result += 1
            end
          end
        end
      end
    end
    return result
  end

  def find_total_unread(tutor)
    result = 0
    if tutor.courses
      tutor.courses.each do |course|
        result += find_unread_from_course(course)
      end
    end
    return result
  end

  def clear_unread(lesson)
    if lesson.posts
      lesson.posts.where(read: false).each do |post|
        post.update_attribute(:read, true)
        if post.messages
          post.messages.where(read: false).each do |message|
            message.update_attribute(:read, true)
          end
        end
      end
    end
  end
end
