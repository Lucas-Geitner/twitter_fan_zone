class Message < ApplicationRecord
  belongs_to :fan
  validates :text, length: {maximum: 140}
end
