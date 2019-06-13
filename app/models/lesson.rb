class Lesson < ApplicationRecord
  belongs_to :course

  default_scope -> { order(:created_at) }

  validates :course_id,
    presence: true

  validates :name,
    presence: true,
    length: { maximum: 50 }

  validates :description,
    presence: true
end
