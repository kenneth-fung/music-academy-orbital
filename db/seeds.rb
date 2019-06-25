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
                activated_at: Time.now)

Tutor.create!(name:  "Runding",
              email: "wangrunding@gmail.com",
              password:              "wangrun123ding",
              password_confirmation: "wangrun123ding",
              activated:    true,
              activated_at: Time.now)

Student.create!(name:  "Admin Student",
                email: "admin@student.com",
                password:              "wangrun123ding",
                password_confirmation: "wangrun123ding",
                admin: true,
                activated:    true,
                activated_at: Time.now)

Tutor.create!(name:  "Admin Tutor",
              email: "admin@tutor.com",
              password:              "wangrun123ding",
              password_confirmation: "wangrun123ding",
              admin:        true,
              activated:    true,
              activated_at: Time.now)

# Tutors
(1..40).each do |n|
  name = Faker::Name.name
  email = "#{name.gsub(/[^a-z0-9]/i, '')}#{n}@gmail.org"
  password = "password"
  Tutor.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password,
                activated:    true,
                activated_at: Time.now)
end

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
                  activated_at: Time.now)
end

# Courses
rand(300..400).times do
  instrument = Faker::Music.instrument
  grade = 'Grade + 'rand(1..10).to_s
  title = instrument + ': ' + grade
  content = Faker::Lorem.paragraph(rand(15..50))
  price = rand(2000).to_f / 100.to_f
  tutor = Tutor.find(Tutor.pluck(:id).sample)
  course = tutor.courses.create!(title:   title, 
                                 content: content, 
                                 price:   price)

  # Lessons
  rand(1..12).times do
    name = Faker::Food.dish
    description = Faker::Food.description
    course.lessons.create!(name: name, description: description)
  end

  # Tags
  course.tags.create!(name: instrument)
  course.tags.create!(name: grade)
end

# Subscriptions
students = Student.order('RANDOM()')
students.each do |student|
  number_of_subscriptions = rand(15..30)
  courses = Course.order('RANDOM()').limit(number_of_subscriptions)
  courses.each do |course|
    student.subscribe(course)
  end
end
