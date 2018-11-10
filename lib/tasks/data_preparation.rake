namespace :data do
  desc 'Recalculate post and topic score'
  task score: :environment do
    puts 'Calculating post and topic score...'

    posts = Post.includes(:votings).all.map do |post|
      post.tap { post.score = calculate_voting_score(post) }
    end
    Post.import(posts, on_duplicate_key_update: [:score])

    puts 'Done'
  end

  def calculate_voting_score(post)
    post.votings.inject(0) { |sum, vote| sum + vote.value }
  end

  desc 'Calculate counter cache columns after seeding'
  task counter: :environment do
    puts 'Calculating counter cache columns....'

    Category.all.each do |category|
      %i[topics posts].each do |association|
        Category.reset_counters(category.id, association)
      end
    end

    Topic.all.each do |topic|
      Topic.reset_counters(topic.id, :posts)
    end

    puts 'Done'
  end
end
