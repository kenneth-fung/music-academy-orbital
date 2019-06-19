class Course < ApplicationRecord
  belongs_to :tutor
  has_many :lessons, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :students, through: :subscriptions, source: :student

  has_one_attached :image
  validate :image_file_type

  default_scope -> { order(created_at: :desc) }

  validates :title,
    presence: true,
    length: { maximum: 50 }

  validates :content,
    presence: true

  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  validates :tutor,
    presence: true

  private

  # Validates that the image is of the correct file type
  def image_file_type
    if image.attached? && !image.content_type.in?(%w[image/png image/jpeg image/gif])
      image.purge # delete the uploaded image
      errors.add(:image, 'must be a PNG, JPEG, or GIF file.')
    end
  end
end
