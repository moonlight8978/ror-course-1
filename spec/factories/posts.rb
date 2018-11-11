FactoryBot.define do
  factory :post do
    topic
    category { topic.category }
    association :creator, factory: :user
    content { Faker::Lorem.paragraph(2, true) }
    deleted_at { nil }

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
