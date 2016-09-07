class Fan < ApplicationRecord
  CATEGORY=["sympathisant", "opposant", "neutre"]
  has_many :posts
  validates :name, presence: true, uniqueness: true
end
