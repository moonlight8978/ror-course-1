FactoryBot.define do
  factory :category do
    name { Faker::Football.team }
  end
end
