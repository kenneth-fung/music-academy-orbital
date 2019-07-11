class Subscription < ApplicationRecord
  belongs_to :student
  belongs_to :course
  validates :student_id, presence: true
  validates :course_id, presence: true

  # Updates the lesson at which a student left off
  def update_left_off(lesson_id)
    update_attribute(:left_off, lesson_id)
  end

  def paypal_url(return_path)

    app_host = Rails.env.development? ?
      "http://localhost:3000" :
      "#{Rails.application.credentials.paypal[:app_host]}"

    business = Rails.env.development? ?
      "merchant@musicacademy.com" :
      course.tutor.email

    values = {
      business: business,
      cmd: "_xclick",
      upload: 1,
      return: app_host + "#{return_path}",
      invoice: id,
      amount: course.price,
      item_name: course.title,
      item_number: course.id,
      quantity: '1'
    }

    paypal_path = Rails.env.development? ?
      "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query :
      "#{Rails.application.credentials.paypal[:paypal_host]}/cgi-bin/webscr?" + values.to_query
  end
end
