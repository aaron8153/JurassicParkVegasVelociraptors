module V1
  class SpeciesSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :carnivorous

  end
end