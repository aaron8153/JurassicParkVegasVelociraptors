FactoryBot.define do
  factory :cage do
    name { "'#{Faker::Creature::Animal.unique.name}' Cage" }
    max_capacity { 10 }
    power_status { Cage::DOWN } #powered down

    trait :powered do
      power_status { Cage::ACTIVE }
    end

    trait :unpowered do
      power_status { Cage::DOWN }
    end
  end
end
