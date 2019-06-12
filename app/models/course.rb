class Course < ApplicationRecord
  belongs_to :tutor
  has_many :subscriptions, dependent: :destroy
  has_many :students, through: :subscriptions, source: :student

  has_one_attached :image

  default_scope -> { order(created_at: :desc) }

  validates :title, presence: true
  validates :content, presence: true
end
