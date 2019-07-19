# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Student.create!(name:  "Runding",
                email: "wangrunding@gmail.com",
                password:              "wangrun123ding",
                password_confirmation: "wangrun123ding",
                activated:    true,
                activated_at: 1.month.ago)

Tutor.create!(name:  "Runding",
              email: "wangrunding@gmail.com",
              password:              "wangrun123ding",
              password_confirmation: "wangrun123ding",

              qualification: 'Degree in Music, Masters in Experimental Funk, PhD in Post-Orbital Rock',

              bio: "Runding graduated from the University of Music with a Degree in Music. 
              From there, he went on to complete his Masters in Experimental Funk, 
              before finally completing his PhD in Post-Orbital Rock. 
              Now, he has come to the Music Academy to spread his love and passion for the musical arts. 
              He is proficient in many instruments, most notably the Piano, Guitar, Oboe, Electric Guitar, 
              Xylophone, Drums, Violin, Harp, Bagpipes, and most importantly the Saxophone.",

              activated:    true,
              activated_at: 1.month.ago)

Student.create!(name:  "Mr. Doctor (admin)",
                email: "admin@student.com",
                password:              "wangrun123ding",
                password_confirmation: "wangrun123ding",
                admin: true,
                activated:    true,
                activated_at: 1.month.ago)

Tutor.create!(name:  "Master Doctor (admin)",
              email: "admin@tutor.com",
              password:              "wangrun123ding",
              password_confirmation: "wangrun123ding",
              qualification: 'Degree in Administration, PhD in User Deletion',
              bio: "Y'all better keep the peace or I'll delete you off the internet!",
              admin:        true,
              activated:    true,
              activated_at: 1.month.ago)

# Tutors
qualifications = %w[Degree Masters PhD Maestro Guru Sensei Tutor Encik Grade\ 10]
(1..40).each do |n|
  name = Faker::Name.name
  email = "#{name.gsub(/[^a-z0-9]/i, '')}#{n}@gmail.com"
  password = "password"
  qualification = "#{qualifications.sample} in #{Faker::Music.instrument}, from #{Faker::Educator.university}"
  bio = Faker::Lorem.paragraph(rand(15..30))
  Tutor.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password,
                qualification: qualification,
                bio: bio,
                activated:    true,
                activated_at: 1.month.ago)
end

Tutor.find_each {|tutor| tutor.update_attributes(created_at: 1.month.ago, updated_at: 1.month.ago)}

# Students
(41..80).each do |n|
  name = Faker::Name.name
  email = "#{name.gsub(/[^a-z0-9]/i, '')}#{n}@gmail.org"
  password = "password"
  Student.create!(name:  name,
                  email: email,
                  password:              password,
                  password_confirmation: password,
                  activated:    true,
                  activated_at: 1.month.ago)
end

Student.find_each {|student| student.update_attributes(created_at: 1.month.ago, updated_at: 1.month.ago)}

# Tags Data
tags = %w[fun music instrument learn best great musician bootcamp course]

# Courses
rand(300..400).times do
  instrument    = Faker::Music.instrument
  grade         = 'Grade ' + rand(1..10).to_s
  title         = instrument + ': ' + grade
  content       = Faker::Lorem.paragraph(rand(15..50))
  target        = Faker::Lorem.paragraph(rand(3..10))
  prerequisites = Faker::Lorem.paragraph(rand(2..5))
  language      = "English"
  price         = rand(2000).to_f / 100.to_f

  # Tags
  tag_list = [instrument.downcase, grade.downcase]
  case grade[-1].to_i
  when 1..4
    tag_list << 'beginner'
  when 5..7
    tag_list << 'intermediate'
  when 8..10
    tag_list << 'advanced'
  else
  end
  3.times do
    tag = tags.sample
    tag_list << tag unless tag_list.include?(tag)
  end
  tag_list = tag_list.join(", ")

  tutor      = Tutor.find(Tutor.pluck(:id).sample)
  course     = tutor.courses.create!(title:   title, 
                                     content: content,
                                     target: target,
                                     prerequisites: prerequisites,
                                     language: language,
                                     price:   price,
                                     tag_list: tag_list)

  course.update_attributes(created_at: 1.month.ago, updated_at: 1.month.ago)

  # Lessons
  rand(1..12).times do
    name = Faker::Food.dish
    description = Faker::Food.description
    course.lessons.create!(name: name, description: description)
  end

  course.lessons.each {|lesson| lesson.update_attributes(created_at: 1.month.ago, updated_at: 1.month.ago)}
end

# Subscriptions
students = Student.order(Arel.sql('RANDOM()'))
students.each do |student|
  number_of_subscriptions = rand(35..50)
  courses = Course.order(Arel.sql('RANDOM()')).limit(number_of_subscriptions)
  courses.each do |course|
    student.subscribe(course)

    # Generates a random date/time from within the past month
    subscription_time = Time.now - rand(2592000) # 1 month = 2592000 seconds
    student.subscriptions.find_by(course_id: course.id).update_attributes(created_at: subscription_time, updated_at: subscription_time)

    # Reviews
    if rand > 0.50
      student.reviews.create!(rating: rand(1..5),
                              content: Faker::Lorem.paragraph(rand(1..8)),
                              course: course)

      # Update Course Rating & Popularity
      course.update_attributes(rating: course.rating_calc)
      popularity = course.reviews.count + course.rating + course.students.count
      course.update_attributes(popularity: popularity)
    end
  end
end

# Tutor Popularity & Tutor's Student Count
Tutor.find_each do |tutor|
  popularity = 0
  tutor.courses.each do |course|
    popularity += course.popularity
  end
  tutor.update_columns(popularity: popularity, student_count: tutor.students_unique.count)
end
