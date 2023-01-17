class Species < ApplicationRecord
  has_many :dinosaurs

  validates :name, presence: true
  validates :carnivorous, inclusion: { in: [ true, false ] }
end
