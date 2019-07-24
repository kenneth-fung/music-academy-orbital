# Subscriptions
students = Student.order(Arel.sql('RANDOM()'))
students.each do |student|

  number_of_subscriptions = rand(35..50)

  courses = Course.order(Arel.sql('RANDOM()')).limit(number_of_subscriptions)
  courses.each do |course|

    student.subscribe(course)

    # Generates a random date/time to subscribe at from within the past month
    subscription_time = Time.now - rand(2592000) # 1 month = 2592000 seconds
    student.subscriptions.find_by(course_id: course.id).update_attributes(created_at: subscription_time, updated_at: subscription_time)
    
  end
end

# Update Tutor's Student Count
Tutor.find_each do |tutor|
  tutor.update_attributes(student_count: tutor.students_unique.count)
end
