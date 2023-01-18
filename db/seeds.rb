# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Reset to default
Dinosaur.delete_all
Cage.delete_all
Species.delete_all

carnivores = %w(Tyrannosaurus Velociraptor Spinosaurus Megalosaurus Allosaurus Giganotosaurus Deinonychus Baryonyx Albertosaurus Carnotaurus Dilophosaurus Ceratosaurus Gorgosaurus Acrocanthosaurus Suchomimus Utahraptor Troodon Dromaeosaurus)
herbivors = %w(Brachiosaurus Stegosaurus Ankylosaurus Triceratops Diplodocus Apatosaurus Iguanodon Dryosaurus Camarasaurus Edmontosaurus Ouranosaurus Hadrosaurus Euoplocephalus Pachycephalosaurus Parasaurolophus Psittacosaurus Protoceratops Struthiomimus Maiasaura Leptoceratops)

carnivores.each do |species_name|
  Species.create!(name: species_name, carnivorous: true)
end

herbivors.each do |species_name|
  Species.create!(name: species_name, carnivorous: false)
end

# Add some dinosaurs!
num_species = Species.count
(1..300).map do
  Dinosaur.create!(
    name: Faker::Name.unique.name,
    species: Species.offset(rand(num_species)).first
  )
end

# Make some Cages

# 5 Vacant Powered Down Cages
(1..5).map do
  Cage.create!(
    name: "'#{Faker::Creature::Animal.unique.name.titleize}' Cage",
    max_capacity: 10,
    power_status: Cage::DOWN
  )
end

# 5 Herbivore Cages, Powered
(1..5).map do
  cage = Cage.create!(
    name: "'#{Faker::Creature::Animal.unique.name.titleize}' Cage",
    max_capacity: 10,
    power_status: Cage::ACTIVE
  )

  homeless_herbivores = Dinosaur.homeless.herbivores.limit(rand(5))
  homeless_herbivores.each do |dino|
    cage.add_dinosaur(dino)
  end
end

# 5 Carnivore Cages, Powered
(1..5).map do
  cage = Cage.create!(
    name: "'#{Faker::Creature::Animal.unique.name.titleize}' Cage",
    max_capacity: 10,
    power_status: Cage::ACTIVE
  )

  (1..5).map do
    homeless_dino = Dinosaur.create!(
      name: Faker::Name.unique.name,
      species: Species.carnivorous.offset(rand(carnivores.length)).first
    )
    cage.add_dinosaur(homeless_dino)
  end
end