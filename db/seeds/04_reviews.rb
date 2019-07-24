# Select random number of subscription IDs
subscription_ids = Subscription.pluck(:id).sample(rand(Subscription.count))
subscription_ids = subscription_ids.sample(rand(subscription_ids.count))

# Select random number of subscriptions from selected IDs
subscriptions = Subscription.where(id: subscription_ids)

subscriptions.each do |subscription|
  student = Student.find(subscription.student_id)
  course = Course.find(subscription.course_id)

  # Generate review at a random time
  review_time = (Time.now - course.created_at).round
  review = student.reviews.create!(rating: rand(1..5),
                                   content: Faker::Lorem.paragraph(rand(1..8)),
                                   course: course,
                                   created_at: review_time,
                                   updated_at: review_time)

  # Update Course Rating & Popularity
  course.update_attributes(rating: course.rating_calc)
  popularity = course.reviews.count + course.rating + course.students.count
  course.update_attributes(popularity: popularity)
end

# Generate notifications for one out of a hundred reviews
review_ids = Review.pluck(:id).sample((Review.count / 100).round)
reviews = Review.where(id: review_ids)

reviews.each do |review|
  Notification.create!(content: "New Review for #{review.course.title}",
                       user_id: review.course.tutor.id,
                       user_type: 'Tutor',
                       origin_type: 'Review',
                       origin_id: review.id)
end

# Tutor Popularity
Tutor.find_each do |tutor|
  popularity = 0
  tutor.courses.each do |course|
    popularity += course.popularity
  end
  tutor.update_attributes(popularity: popularity)
end
