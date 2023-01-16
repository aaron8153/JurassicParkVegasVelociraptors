FactoryBot.define do
  factory :cage do
    name { Faker::Name.unique.name }
    max_capacity { 10 }
    power_status { false } #powered down

    trait :powered do
      power_status { true }
    end
  end
end
