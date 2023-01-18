module V1
  class CageSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :max_capacity, :occupancy

    belongs_to :species
    has_many :dinosaurs

    attribute :power_status do |object|
      object.power_status ? "ACTIVE" : "DOWN"
    end

    attribute :occupancy do |object|
      object.capacity
    end

  end
end