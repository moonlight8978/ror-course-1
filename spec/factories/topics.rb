FactoryBot.define do
  factory :topic do
    transient do
      count { 0 }
    end

    association :creator, factory: :user
    category
    name { "#{Faker::Football.player} #{SecureRandom.uuid}" }
    status { :opening }
    deleted_at { nil }

    first_post do
      association :post,
        topic: nil,
        creator: @instance.creator,
        category: @instance.category
    end

    trait :with_posts do
      after(:create) do |topic|
        create_list(:post, (10..20).to_a.sample, topic: topic) if count > 0
      end
    end
  end
end
