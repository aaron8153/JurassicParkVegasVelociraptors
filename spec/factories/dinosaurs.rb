FactoryBot.define do
  factory :dinosaur do
    name { Faker::Name.unique.name }
    species { nil }
    cage { nil }
  end
end
