FactoryBot.define do
  factory :user do
    transient do
      banned_from { nil }
      manage { nil }
    end

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

    after(:create) do |user, options|
      if options.banned_from.present?
        create(:category_banning, user: user, category: options.banned_from)
      end

      if options.manage.present?
        create(:category_management, manager: user, category: options.manage)
      end
    end
  end
end
