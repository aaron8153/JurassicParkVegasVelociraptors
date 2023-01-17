class Cage < ApplicationRecord
  has_many :dinosaurs
  belongs_to :species, optional: true

  validates :name, :max_capacity, presence: true
  validates_uniqueness_of :name
  validate :validate_power_status, on: :update

  ACTIVE = true
  DOWN = false

  scope :active, -> { where(power_status: ACTIVE) }
  scope :down, -> { where(power_status: DOWN) }

  scope :herbivore_friendly, -> { where(species_id: nil) }
  scope :is_same_species, -> (species) { where(species: species) }

  scope :vacant, -> { left_outer_joins(:dinosaurs).where(dinosaurs: { id: nil }) }
  scope :has_room, -> { joins(:dinosaurs).group(:id).having("count(dinosaurs.id) > 0 AND count(dinosaurs.id) < max_capacity") }
  scope :full, -> { joins(:dinosaurs).group(:id).having("count(dinosaurs.id) = max_capacity") }


  def add_dinosaur(dino)
    if active?
      if vacant?
        if dino.carnivore?
          set_species(dino)
        end
        settle_dinosaur(dino)
      elsif partially_filled?
        if herbivore_friendly?
          if dino.herbivore?
            settle_dinosaur(dino)
          else
            errors.add(:base, "Cannot add carnivorous dinosaurs to an herbivore cage.")
          end
        elsif is_same_species?(dino)
          settle_dinosaur(dino)
        else
          if dino.carnivore?
            errors.add(:base, "Cannot add multiple carnivorous species to a cage.")
          else
            errors.add(:base, "Cannot add an herbivore species to a carnivore cage.")
          end
        end

      else #cage is full
        errors.add(:base, "The cage is full.")
      end
    else
      errors.add(:base, "Cannot add settle dinosaurs into a cage that is powered down.")
    end
  end

  def active?
    power_status
  end

  def capacity
    dinosaurs.count
  end

  def vacant?
    capacity == 0
  end

  def partially_filled?
    capacity > 0 && !full?
  end

  def full?
    capacity >= max_capacity
  end

  def herbivore_friendly?
    species.nil?
  end

  def is_same_species?(dino)
    species == dino.species
  end

  def set_species(dino)
    self.update!(species: dino.species)
  end

  def settle_dinosaur(dino)
    dino.cage = self
    dino.save!
  end

  private

  def validate_power_status
    if power_status == DOWN && dinosaurs.count > 0
      errors.add(:power_status, "Cannot turn off cage when filled with dinosaurs")
    end
  end

end
