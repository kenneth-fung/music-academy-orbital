class Post < ApplicationRecord
  belongs_to :lesson
  has_many :messages, dependent: :destroy

  validates :content,
    presence: true

  validates :lesson_id,
    presence: true,
    numericality: { greater_than_or_equal_to: 1 }

  validates :user_type,
    presence: true

  validates :user_id,
    presence: true,
    numericality: { greater_than_or_equal_to: 1 }

  # Returns the user who sent the post
  def sender
    self.user_type.constantize.find(self.user_id)
  end

end
