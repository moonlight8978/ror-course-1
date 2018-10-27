FactoryBot.define do
  factory :topic do
    association :creator, factory: :user
    category
    name { Faker::Football.unique.coach }
    status { :opening }

    trait :with_posts do
      after(:create) do |topic|
        create_list(:post, (10..20).to_a.sample, topic: topic)
      end
    end
  end
end
