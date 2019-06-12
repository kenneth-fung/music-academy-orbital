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
                password_confirmation: "wangrun123ding")

Tutor.create!(name:  "Runding",
              email: "wangrunding@gmail.com",
              password:              "wangrun123ding",
              password_confirmation: "wangrun123ding")

# Tutors
(1..40).each do |n|
  name  = Faker::Name.name + " " + n.to_s
  email = "example-#{n}@gmail.org"
  password = "password"
  Tutor.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password)
end

# Students
(41..80).each do |n|
  name  = Faker::Name.name + " " + n.to_s
  email = "example-#{n+41}@gmail.org"
  password = "password"
  Student.create!(name:  name,
                  email: email,
                  password:              password,
                  password_confirmation: password)
end

# Courses
Tutor.all.each do |tutor|
  (rand(1..50)).times do
    title = Faker::Music.instrument + ": Grade " + rand(1..10).to_s
    content = Faker::Lorem.sentence(rand(3..8))
    tutor.courses.create!(title: title, content: content)
  end
end

students = Student.all
courses = Course.all
student_ids = students[0..25]
course_ids = courses[0..40]
student_ids.each do |student|
  course_ids.each do |course|
    student.subscribe(course)
  end
end
