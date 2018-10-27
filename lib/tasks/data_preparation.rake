namespace :data_preparation do
  desc 'Recalculate post and topic score'
  task calculate_score: :environment do
    Post.includes(:votings).all.each do |post|
      calculate_voting_score(post)
    end

    Topic.includes(:votings).all.each do |topic|
      calculate_voting_score(topic)
    end
  end

  def calculate_voting_score(votable)
    votable.votings.inject(0) { |sum, vote| sum + vote.value }
  end
end
