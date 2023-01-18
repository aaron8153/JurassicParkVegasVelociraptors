module V1
  class DinosaurSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name
    belongs_to :species
    belongs_to :cage

  end
end