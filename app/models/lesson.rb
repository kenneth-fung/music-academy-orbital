class Lesson < ApplicationRecord
  belongs_to :course

  has_one_attached :video

  validate :video_file_type

  default_scope -> { order(:created_at) }

  validates :course_id,
    presence: true

  validates :name,
    presence: true,
    length: { maximum: 50 }

  validates :description,
    presence: true

  private

  # Validates that the video is of the correct file type
  def video_file_type
    if video.attached? && !video.content_type.in?(%w[video/mp4 video/wmv])
      video.purge # delete the uploaded video
      errors.add(:video, 'must be an MP4 or WMV file.')
    end
  end
end
