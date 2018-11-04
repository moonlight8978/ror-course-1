FactoryBot.define do
  factory :category do
    name { "#{Faker::Football.team} #{SecureRandom.uuid}" }
  end
end
