class Species < ApplicationRecord
  has_many :dinosaurs
  has_many :cages

  validates :name, presence: true
  validates :carnivorous, inclusion: { in: [ true, false ] }

  scope :carnivorous, -> { where(carnivorous: true) }
  scope :herbivorous, -> { where(carnivorous: false) }
end
