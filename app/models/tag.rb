class Tag < ApplicationRecord
  has_many :taggings
  has_many :courses, through: :taggings
end
