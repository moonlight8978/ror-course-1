namespace :data do
  desc 'Recalculate post and topic score'
  task score: :environment do
    votable_subjects = [Post, Topic]

    votable_subjects.each do |subject|
      votables = subject.includes(:votings).all.map do |votable|
        votable.tap { votable.score = calculate_voting_score(votable) }
      end
      subject.import(votables, on_duplicate_key_update: [:score])
    end
  end

  def calculate_voting_score(votable)
    votable.votings.inject(0) { |sum, vote| sum + vote.value }
  end
end
