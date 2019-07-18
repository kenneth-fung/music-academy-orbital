module TutorsHelper

  # Returns the Gravatar for a given tutor
  def gravatar_for(tutor, size: 80)
    gravatar_id = Digest::MD5::hexdigest(tutor.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: tutor.name, class: "gravatar rounded-circle")
  end
end
