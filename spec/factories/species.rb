FactoryBot.define do
  factory :species do
    name { Faker::Creature::Animal.unique.name }
    carnivorous { false }

    trait :carnivore_diet do
      carnivorous { true }
    end
    trait :herbivore_diet do
      carnivorous { false }
    end
  end
end
