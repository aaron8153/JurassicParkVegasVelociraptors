require 'rails_helper'

RSpec.describe Cage, type: :model do

  let!(:powered_cage) {
    create(:cage,
           :powered,
           species: nil)
  }

  let!(:species_herbivore) { create(:species, :herbivore_diet)}
  let!(:species_herbivore2) { create(:species, :herbivore_diet)}

  let!(:species_carnivore) { create(:species, :carnivore_diet)}
  let!(:species_carnivore2) { create(:species, :carnivore_diet)}

  let!(:homeless_herbivore) {
    create(:dinosaur,
           species: species_herbivore,
           cage: nil)
  }
  let!(:homeless_herbivore2) {
    create(:dinosaur,
           species: species_herbivore2,
           cage: nil)
  }

  let!(:homeless_carnivore) {
    create(:dinosaur,
           species: species_carnivore,
           cage: nil)
  }
  let!(:homeless_carnivore2) {
    create(:dinosaur,
           species: species_carnivore2,
           cage: nil)
  }


  describe "validations" do
    it { should belong_to(:species).optional }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:max_capacity) }
  end

  describe "that is empty" do
    it "allows any dinosaur to enter an empty cage" do
      powered_cage.add_dinosaur(homeless_herbivore)
      expect(powered_cage.dinosaurs.count).to eq(1)
    end

  end

  describe "that is occupied but not full" do
    describe "has a herbivore inside" do
      let!(:homed_herbivore) {
        create(:dinosaur,
               species: species_herbivore,
               cage: nil)
      }

      before(:each) do
        powered_cage.add_dinosaur(homed_herbivore)
      end

      it "allows 2 or more herbivore species into the cage" do
        powered_cage.add_dinosaur(homeless_herbivore)
        powered_cage.add_dinosaur(homeless_herbivore2)
        expect(powered_cage.capacity).to eq(3)
      end
      it "does not allow a carnivore to enter an herbivore cage" do
        powered_cage.add_dinosaur(homeless_carnivore)
        expect(powered_cage.capacity).to eq(1)
        expect(powered_cage.errors.messages[:base]).to eq ['Cannot add carnivorous dinosaurs to an herbivore cage.']

      end
    end
    describe "has a carnivore inside" do
      let!(:homed_carnivore) {
        create(:dinosaur,
               species: species_carnivore,
               cage: nil)
      }
      let!(:carnivore_same_species) {
        create(:dinosaur,
               species: species_carnivore,
               cage: nil)
      }
      let!(:carnivore_different_species) {
        create(:dinosaur,
               species: species_carnivore2,
               cage: nil)
      }

      before(:each) do
        powered_cage.add_dinosaur(homed_carnivore)
      end

      it "allows a carnivorous dinosaur with the same species inside" do
        powered_cage.add_dinosaur(carnivore_same_species)
        expect(powered_cage.capacity).to eq(2)
        expect(carnivore_same_species.cage).to_not be_nil
      end

      it "does not allow a different carnivorous dinosaur species inside" do
        powered_cage.add_dinosaur(carnivore_different_species)
        expect(powered_cage.capacity).to eq(1)
        expect(carnivore_different_species.cage).to be_nil
        expect(powered_cage.errors.messages[:base]).to eq ['Cannot add multiple carnivorous species to a cage.']
      end

      it "does not allow an herbivore dinosaur species inside" do
        powered_cage.add_dinosaur(homeless_herbivore)
        expect(powered_cage.capacity).to eq(1)
        expect(homeless_herbivore.cage).to be_nil
        expect(powered_cage.errors.messages[:base]).to eq ['Cannot add an herbivore species to a carnivore cage.']
      end
    end

  end

  describe "that is full" do
    let!(:full_cage) {
      create(:cage,
             :powered,
             max_capacity: 1,
             species: species_herbivore)
    }

    let!(:dinosaur) {
      create(:dinosaur,
             species: species_herbivore,
             cage: full_cage)
    }
    let!(:dinosaur2) {
      create(:dinosaur,
             species: species_herbivore,
             cage: nil)
    }

    it "does not allow a cage to fill beyond max_capacity" do
      full_cage.add_dinosaur(dinosaur2)
      expect(full_cage.capacity).to be(1)
    end
  end

  describe "that is powered" do

    describe "that is empty" do
      it "can power down" do
        powered_cage.power_status = false
        expect(powered_cage).to be_valid
      end
    end
    describe "that is occupied but not full" do
      before(:each) do
        powered_cage.add_dinosaur(homeless_carnivore)
      end

      it "can not power down" do
        powered_cage.power_status = false
        expect(powered_cage).to be_invalid
      end
    end
    describe "that is full" do
      before(:each) do
        powered_cage.species = species_carnivore
        create_list :dinosaur, powered_cage.max_capacity, species: species_carnivore, cage: powered_cage
      end
      it "can not power down" do
        powered_cage.power_status = false
        expect(powered_cage).to be_invalid
      end
    end
  end

  describe "that is powered down" do

    let!(:unpowered_cage) {
      create(:cage,
             :unpowered,
             species: nil)
    }

    describe "that is empty" do
      it "can power up" do
        unpowered_cage.power_status = true
        expect(unpowered_cage).to be_valid
      end
      it "does not allow a dinosaur to be settled" do
        unpowered_cage.add_dinosaur(homeless_herbivore)
        expect(unpowered_cage.capacity).to eq(0)
        expect(unpowered_cage.errors.messages[:base]).to eq ['Cannot add settle dinosaurs into a cage that is powered down.']
      end
    end
  end

end
