FactoryBot.define do
  factory :voting do
    association :voter, factory: :user
    post
    value { [-1, 1].sample }
  end
end
