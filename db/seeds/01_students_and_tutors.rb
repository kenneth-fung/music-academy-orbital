Student.create!(name:  "Runding",
                email: "wangrunding@gmail.com",
                password:              "wangrun123ding",
                password_confirmation: "wangrun123ding",
                activated:    true,
                activated_at: 1.month.ago)

custom_bio =
  "Runding graduated from the University of Music with a Degree in Music. From there, he went on to complete his Masters in Experimental Funk, before finally completing his PhD in Post-Orbital Rock. Now, he has come to the Music Academy to spread his love and passion for the musical arts. He is proficient in many instruments, most notably the Piano, Guitar, Oboe, Electric Guitar, Xylophone, Drums, Violin, Harp, Bagpipes, and most importantly the Saxophone."

Tutor.create!(name:  "Runding",
              email: "wangrunding@gmail.com",
              password:              "wangrun123ding",
              password_confirmation: "wangrun123ding",

              qualification: 'Degree in Music, Masters in Experimental Funk, PhD in Post-Orbital Rock',
              bio: custom_bio,

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
                activated_at: 1.month.ago, 
                created_at: 1.month.ago, 
                updated_at: 1.month.ago)
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
                  private: rand > 0.75,
                  activated:    true,
                  activated_at: 1.month.ago, 
                  created_at: 1.month.ago, 
                  updated_at: 1.month.ago)
end
