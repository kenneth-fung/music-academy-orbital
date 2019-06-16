module StudentsHelper

  # Returns the Gravatar for a given student
  def gravatar_for(student, size: 80)
    gravatar_id = Digest::MD5::hexdigest(student.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: student.name, class: "gravatar")
  end
end
