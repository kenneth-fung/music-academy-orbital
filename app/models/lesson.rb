class Lesson < ApplicationRecord
  belongs_to :course

  validates :course_id,
    presence: true

  validates :name,
    presence: true,
    length: { maximum: 50 }

  validates :description,
    presence: true
end
