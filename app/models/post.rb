class Post < ApplicationRecord
  belongs_to :lesson
  has_many :messages, dependent: :destroy

  validates :content,
    presence: true
end
