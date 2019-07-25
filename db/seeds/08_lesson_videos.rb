Tutor.first.courses.each do |course|
  course.lessons.each do |lesson|
    # Lesson Video
    filename = "lesson_video_#{rand(1..8)}.mp4"
    file = open("https://d3dtyxx5zkz3x7.cloudfront.net/seeds/#{filename}")
    lesson.video.attach(io: file, filename: filename, content_type: 'video/mp4') if file.present?
  end
end
