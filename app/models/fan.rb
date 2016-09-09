class Fan < ApplicationRecord
  CATEGORIES=["Sympathisant", "Opposant", "Neutre", "Presse", "Inconnu", "Militant"]
  CONTACTS=["Non-contacté", "A contacter", "Contacté", "Sans intérêt"]
  has_many :posts
  has_many :messages
  validates :name, presence: true, uniqueness: true
end
