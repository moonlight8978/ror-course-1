FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.hex(10)}_#{Faker::Internet.email}" }
    password { '1111' }
    username { "#{Faker::Dota.player} #{SecureRandom.hex(10)}" }
    role { :user }

    trait :moderator do
      role { :moderator }
    end

    trait :admin do
      role { :admin }
    end
  end
end
