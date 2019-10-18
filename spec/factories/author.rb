FactoryBot.define do
  factory :author do
    name      { Faker::Name.name }
    biography { Faker::Lorem.paragraph }
  end
end
