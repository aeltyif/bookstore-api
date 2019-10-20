FactoryBot.define do
  factory :author do
    name      { Faker::Name.name }
    biography { Faker::Lorem.paragraph }

    trait :invalid do
      name { nil }
    end
  end
end
