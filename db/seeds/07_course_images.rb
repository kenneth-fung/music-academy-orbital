Course.find_each do |course|
  # Course Image
  filename = "course_image_#{rand(1..8)}.jpg"
  file = open("https://d3dtyxx5zkz3x7.cloudfront.net/seeds/#{filename}")
  course.image.attach(io: file, filename: filename, content_type: 'image/jpeg') if file.present?
end
