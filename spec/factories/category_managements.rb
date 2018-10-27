FactoryBot.define do
  factory :category_management do
    category
    association :manager, factory: %i[user moderator]
  end
end
