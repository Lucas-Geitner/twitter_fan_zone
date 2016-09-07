class Fan < ApplicationRecord
  CATEGORY=["sympathisant", "opposant", "neutre", "presse", "unknow"]
  has_many :posts
  validates :name, presence: true, uniqueness: true
end
