class Dinosaur < ApplicationRecord
  belongs_to :species
  belongs_to :cage, optional: true

  validates :name, :species, presence: true

  def carnivore?
    species.carnivorous
  end

  def herbivore?
    !species.carnivorous
  end

end
