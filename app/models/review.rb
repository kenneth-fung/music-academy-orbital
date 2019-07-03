class Review < ApplicationRecord
  belongs_to :student
  belongs_to :course

  scope :newest,      -> { order(created_at: :desc) }
  scope :oldest,      -> { order(created_at: :asc) }
  scope :rating_high, -> { order(rating: :desc) }
  scope :rating_low,  -> { order(rating: :asc) }

  validates :student_id,
    presence: true

  validates :course_id,
    presence: true

  validates :rating,
    presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  validates :content,
    presence: true

  # Changes the scope (order of reviews) based on sort param
  def Review.sort(sort_by)
    case sort_by
    when 'newest'
      newest
    when 'oldest'
      oldest
    when 'rating_high'
      rating_high
    when 'rating_low'
      rating_low
    else
      newest
    end
  end

end
