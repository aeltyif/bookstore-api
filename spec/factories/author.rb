FactoryBot.define do
  factory :author do
    name      { Faker::Name.name }
    biography { Faker::Lorem.paragraph }
    issue_id  { Faker::Number.number(digits: 5) }

    trait :invalid do
      name { nil }
    end
  end
end
