class Species < ApplicationRecord
  has_many :dinosaurs

  validates :name, :carnivorous, presence: true
end
