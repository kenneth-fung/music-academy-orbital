class Subscription < ApplicationRecord
  belongs_to :student
  belongs_to :course
  validates :student_id, presence: true
  validates :course_id, presence: true

  # Updates the lesson at which a student left off
  def update_left_off(lesson_id)
    update_attribute(:left_off, lesson_id)
  end
end
