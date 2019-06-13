class Tutor < ApplicationRecord
  has_many :courses, dependent: :destroy
  #has_many :subscriptions, dependent: :destroy
  #has_many :students, through: :subscriptions, source: :student

  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, 
    presence: true, 
    length:     { maximum: 255 },
    format:     { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :name,
    presence: true,
    length: { maximum: 50 }

  has_secure_password
  validates :password, 
    presence: true, 
    length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def Tutor.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? 
      BCrypt::Engine::MIN_COST : 
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Gets all students across all courses (NOT UNIQUE)
  def students
    Student
    .joins(subscriptions: :course)
    .where(courses: { tutor_id: self.id })
  end

  # Gets all unique students across all courses
  def students_unique
    Student
    .joins(subscriptions: :course)
    .where(courses: { tutor_id: self.id })
    .distinct
  end
end
