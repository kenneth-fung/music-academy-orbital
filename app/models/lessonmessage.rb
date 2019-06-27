class Lessonmessage < ApplicationRecord
  belongs_to :message
  belongs_to :lesson
end
