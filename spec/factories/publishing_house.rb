FactoryBot.define do
  factory :publishing_house do
    name     { Faker::Name.name }
    discount { Faker::Number.positive(from: 15, to: 60) }

    trait :invalid do
      name { nil }
    end
  end
end
