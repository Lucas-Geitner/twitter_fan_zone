class Fan < ApplicationRecord
  CATEGORY=["sympathisant", "opposant", "neutre"]
  has_many :posts
end
