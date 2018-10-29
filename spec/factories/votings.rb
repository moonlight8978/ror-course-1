FactoryBot.define do
  factory :post_voting, class: 'Voting' do
    association :voter, factory: :user
    association :votable, factory: :post
    value { [-1, 1].sample }
  end

  factory :topic_voting, class: 'Voting' do
    association :voter, factory: :user
    association :votable, factory: :topic
    value { [-1, 1].sample }
  end
end
