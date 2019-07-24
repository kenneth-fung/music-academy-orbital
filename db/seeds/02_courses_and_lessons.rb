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
                                     tag_list: tag_list, 
                                     created_at: 1.month.ago, 
                                     updated_at: 1.month.ago)

  # Lessons
  rand(1..12).times do
    name = Faker::Food.dish
    description = Faker::Food.description
    course.lessons.create!(name: name, description: description, created_at: 1.month.ago, updated_at: 1.month.ago)
  end
end
