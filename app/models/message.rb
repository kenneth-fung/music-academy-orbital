class Message < ApplicationRecord
  belongs_to :post

  validates :content,
    presence: true

  # Returns the user who sent the message
  def sender
    self.user_type.constantize.find(self.user_id)
  end

end
