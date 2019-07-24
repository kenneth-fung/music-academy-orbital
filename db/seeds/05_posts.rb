# Select random number of subscription IDs
subscription_ids = Subscription.pluck(:id).sample(rand(Subscription.count))
subscription_ids = subscription_ids.sample(rand(subscription_ids.count))

# Select random number of subscriptions from selected IDs
subscriptions = Subscription.where(id: subscription_ids)

subscriptions.each do |subscription|
  student = Student.find(subscription.student_id)
  course = Course.find(subscription.course_id)

  # Select random number of lesson IDs
  lesson_ids = course.lessons.pluck(:id).sample(rand(course.lessons.count))
  # Select the lessons
  lessons = course.lessons.where(id: lesson_ids)

  lessons.each do |lesson|
    
    if rand > 0.50

      # Make a post on subscribed course's lessons
      content = rand > 0.50 ? Faker::Quote.most_interesting_man_in_the_world : Faker::GreekPhilosophers.quote
      post = lesson.posts.create!(content: content,
                                  lesson_id: lesson.id,
                                  user_type: 'Student',
                                  user_id: student.id)

    end
  end
end

# Generate notifications for one out of hundred posts
post_ids = Post.pluck(:id).sample((Post.count / 100).round)
posts = Post.where(id: post_ids)

posts.each do |post|
  Notification.create!(content: "New Question about '#{post.lesson.id} for #{post.lesson.course.id}'",
                       user_id: post.lesson.course.tutor.id,
                       user_type: 'Tutor',
                       origin_type: 'Post',
                       origin_id: post.id)
end
