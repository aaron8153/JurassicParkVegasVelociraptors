FactoryBot.define do
  factory :species do
    name {
      begin
        Faker::Creature::Animal.unique.name
      rescue
        "Name" + rand(999).to_s #handle retry limit in a lame way
      end
    }
    carnivorous { false }

    trait :carnivore_diet do
      carnivorous { true }
    end
    trait :herbivore_diet do
      carnivorous { false }
    end
  end
end
