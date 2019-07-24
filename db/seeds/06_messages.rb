# Select random number of subscription IDs
subscription_ids = Subscription.pluck(:id).sample(rand(Subscription.count))
subscription_ids = subscription_ids.sample(rand(subscription_ids.count))

# Select random number of subscriptions from selected IDs
subscriptions = Subscription.where(id: subscription_ids)

subscriptions.each do |subscription|
  student = Student.find(subscription.student_id)
  course = Course.find(subscription.course_id)

  # Select random lesson IDs
  lesson_ids = course.lessons.pluck(:id).sample(rand(course.lessons.count))
  # Select the lessons
  lessons = course.lessons.where(id: lesson_ids)

  lessons.each do |lesson|
    if lesson.posts.any? && rand > 0.50

      # Choose one random post to comment on
      post = lesson.posts.offset(rand(lesson.posts.count)).first
      unless post.sender == student
        content = rand > 0.50 ? Faker::Quote.yoda : Faker::Hacker.say_something_smart
        sent_message = post.messages.create!(content: content,
                                             post_id: post.id,
                                             user_type: 'Student',
                                             user_id: student.id)

      end
    end
  end
end

# Generate notifications for one out of hundred messages
message_ids = Message.pluck(:id).sample((Message.count / 100).round)
messages = Message.where(id: message_ids)

messages.each do |sent_message|
  post = sent_message.post
  notification = "New Reply to #{post.content}"
  Notification.create!(content: notification,
                       user_id: post.sender.id,
                       user_type: post.sender.class.name,
                       origin_type: 'Message',
                       origin_id: sent_message.id) unless post.sender == sent_message.sender

  users = []
  post.messages.each do |message|
    users << message.sender unless users.include?(message.sender) || post.sender == message.sender
  end

  users.each do |user|
    Notification.create!(content: notification,
                         user_id: user.id,
                         user_type: user.class.name,
                         origin_type: 'Message',
                         origin_id: sent_message.id) unless user == sent_message.sender
  end
end
