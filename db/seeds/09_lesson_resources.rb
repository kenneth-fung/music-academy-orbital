# Lesson Resources
resources = %w[
  beethoven.mp3 
  cannon.png 
  canon_in_d.mp3 
  dummy.pdf 
  empty_spaces.png 
  haydn_adagio.mp3 
  Haydn_Cello_Concerto.mp3 
  piano.jpg 
  sample.mp3 
  sample.pdf 
  Tchaikovsky_Nocturne.mp3
]

# Select random lesson IDs
lesson_ids = Lesson.pluck(:id).sample(rand(Lesson.count / 10))
# Select random lessons from the selected IDs
lessons = Lesson.where(id: lesson_ids)

lessons.each do |lesson|
  rand(4).times do
    filename = resources.sample
    file = open("https://d3dtyxx5zkz3x7.cloudfront.net/seeds/lesson_resources/#{filename}")
    lesson.resources.attach(io: file, filename: filename) if file.present?
  end
end
