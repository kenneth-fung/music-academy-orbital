class Student < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :courses, through: :subscriptions, source: :course

  attr_accessor :remember_token

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
    length: { minimum: 6 },
    allow_nil: true

  # Returns the hash digest of the given string.
  def Student.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? 
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Student.new_token
    SecureRandom.urlsafe_base64
  end

  # Subscribes a course
  def subscribe(course)
    courses << course
  end

  # Unsubscribes a course
  def unsubscribe(course)
    courses.delete(course)
  end

  # Returns true if the current user(student) is subscribing the course.
  def subscribing?(course)
    courses.include?(course)
  end
end
