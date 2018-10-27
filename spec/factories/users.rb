FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '1111' }
    username { Faker::Football.unique.player }
    role { :user }

    trait :moderator do
      role { :moderator }
    end

    trait :admin do
      role { :admin }
    end
  end
end
