class Message < ApplicationRecord
  belongs_to :chatroom, polymorphic: true
  has_many :lessonmessages
  has_many :lessons, through: :lessonmessages

end
