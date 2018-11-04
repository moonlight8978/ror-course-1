FactoryBot.define do
  factory :post do
    topic
    category { topic.category }
    association :creator, factory: :user
    content { Faker::Lorem.paragraph(2, true) }
  end
end
