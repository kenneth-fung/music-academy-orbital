class Lesson < ApplicationRecord
  belongs_to :course
  has_many :posts, dependent: :destroy

  has_one_attached :video
  validate :video_file_type

  has_many_attached :resources
  validate :resources_file_types

  default_scope -> { order(:created_at) }

  validates :course_id,
    presence: true

  validates :name,
    presence: true,
    length: { maximum: 50 }

  validates :description,
    presence: true

  after_create :initialize_position

  private

  # Validates that the video is of the correct file type
  def video_file_type
    if video.attached? && !video.content_type.in?(%w[video/mp4 video/wmv])
      video.purge # delete the uploaded video
      errors.add(:video, 'must be an MP4 or WMV file.')
    end
  end

  # Validates that the lesson resources are of the correct file types
  def resources_file_types
    allowed_file_types = %w[attachment/pdf 
    image/png image/jpeg 
    audio/mpeg audio/x-mpeg 
    audio/mp3 audio/x-mp3 
    audio/mpeg3 audio/x-mpeg3 
    audio/mpg audio/x-mpg 
    audio/x-mpegaudio]
    reject_files = false
    # check that each file has the correct file type
    if resources.attached?
      resources.attachments.each do |resource|
        unless resource.content_type.in?(allowed_file_types)
          reject_files = true # found a file with disallowed file type
          errors.add(:resources, 
                     "#{resource.filename} is of the wrong file type (#{resource.content_type}).")
          break
        end
      end
      # check if a file with disallowed file type exists
      if reject_files
        resources.purge # delete the uploaded resources
        errors.add(:resources, 'Resources must be PDFs, images (PNG, JPEG), or sound files (MP3, MPEG).')
      end
    end
  end

  # Initializes the position of the lesson in relation to the other lessons of its course
  def initialize_position
    self.update_attribute(:position, self.course.lessons.count)
  end

end
