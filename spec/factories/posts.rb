FactoryBot.define do
  factory :post do
    topic
    association :creator, factory: :user
    content { Faker::Lorem.paragraph(2, true) }
  end
end
