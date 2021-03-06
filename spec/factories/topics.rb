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
      after(:create) do |topic, options|
        create_list(:post, options.count, topic: topic) if options.count > 0
      end
    end

    trait :deleted do
      deleted_at { Time.current }
    end

    trait :locked do
      status { :locked }
    end
  end
end
