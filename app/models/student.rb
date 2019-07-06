class Student < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :courses, through: :subscriptions, source: :course
  has_many :messages, as: :chatroom
  has_many :reviews, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { email.downcase! }
  before_create :create_activation_digest
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

  # Returns the student's courses ordered by subscription date (newest first)
  def newest_courses
    Course
    .joins(:subscriptions)
    .merge(Subscription
           .where(student_id: self.id)
           .reorder(created_at: :desc))
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = Student.new_token
    update_columns(reset_digest:  Student.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns the student's review for a given course
  def review_for(course)
    self.reviews.where(course_id: course.id).first
  end

  # Returns the student's notifications
  def notifications
    Notification.where(user_type: 'Student', user_id: self.id)
  end

  private

  def create_activation_digest
    self.activation_token = Student.new_token
    self.activation_digest = Student.digest(activation_token)
  end
end
