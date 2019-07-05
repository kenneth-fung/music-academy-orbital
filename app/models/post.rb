class Post < ApplicationRecord
  belongs_to :lesson
  has_many :messages, dependent: :destroy

  validates :content,
    presence: true

  # Returns the user who sent the post
  def sender
    self.user_type.constantize.find(self.user_id)
  end

end
