class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :cage, optional: true

  validates :name, :species, presence: true

  scope :carnivores, -> { joins(:species).where(species: {carnivorous: true}) }
  scope :herbivores, -> { joins(:species).where(species: {carnivorous: false}) }
  scope :homeless, -> { where(cage_id: nil) }

  def carnivore?
    species.carnivorous
  end

  def herbivore?
    !species.carnivorous
  end

end
