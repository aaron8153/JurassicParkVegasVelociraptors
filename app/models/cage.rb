class Cage < ApplicationRecord
  has_many :dinosaurs
  belongs_to :species, optional: true

  validates :name, :max_capacity, presence: true
  validates_uniqueness_of :name
  validate :validate_power_status, on: :update

  def validate_power_status
    if power_status == false && dinosaurs.count > 0
      errors.add(:power_status, "Cannot turn off cage when filled with dinosaurs")
    end
  end
end
