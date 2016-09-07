class Post < ApplicationRecord
  belongs_to :fan
  validates :tweet_id, presence: true, uniqueness: true
end
