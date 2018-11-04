namespace :data do
  desc 'Recalculate post and topic score'
  task score: :environment do
    puts 'Calculating post and topic score...'

    votable_subjects = [Post, Topic]

    votable_subjects.each do |subject|
      votables = subject.includes(:votings).all.map do |votable|
        votable.tap { votable.score = calculate_voting_score(votable) }
      end
      subject.import(votables, on_duplicate_key_update: [:score])
    end

    puts 'Done'
  end

  def calculate_voting_score(votable)
    votable.votings.inject(0) { |sum, vote| sum + vote.value }
  end

  desc 'Calculate counter cache columns after seeding'
  task counter: :environment do
    puts 'Calculating counter cache columns....'

    Category.all.each do |category|
      %i[topics posts].each do |association|
        Category.reset_counters(category.id, association)
      end
    end

    puts 'Done'
  end
end
