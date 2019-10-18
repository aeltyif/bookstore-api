FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    price { Faker::Number.positive(from: 5, to: 30) }
  end
end
