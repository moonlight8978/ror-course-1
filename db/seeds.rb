# Helpers
def seed(model)
  puts "Seeding #{model}..."
  yield
  puts 'Done.'
end

def users_can_interact_with_category(category)
  banned_user_ids = CategoryBanning.select(:id).where(category: category)
    .map(&:id)
  User.where.not(id: banned_user_ids)
end

# Seed
seed :users do
  users = []

  users << User.new(
    email: 'admin@framgia.com',
    password: '1111',
    username: 'Admin depzai',
    role: :admin
  )

  users << User.new(
    email: 'moderator@framgia.com',
    password: '1111',
    username: 'Moderator khoai to',
    role: :moderator
  )

  10.times do
    users << User.new(
      email: "#{SecureRandom.hex(10)}_#{Faker::Internet.email}",
      username: "#{Faker::Dota.player} #{SecureRandom.hex(10)}",
      password: '1111',
      role: :moderator
    )
  end

  100.times do
    users << User.create(
      email: "#{SecureRandom.hex(10)}_#{Faker::Internet.email}",
      username: "#{Faker::Dota.player} #{SecureRandom.hex(10)}",
      password: '1111'
    )
  end

  User.import(users, on_duplicate_key_ignore: true)
end

seed :categories do
  categories = []

  20.times do
    categories << Category.new(
      name: "#{Faker::Football.team} #{SecureRandom.uuid}"
    )
  end

  Category.import(categories, on_duplicate_key_ignore: true)
end

seed :category_managements do
  category_managements = []

  Category.all.each do |category|
    moderators = User.where(role: :moderator)
    3.times do
      category_managements << CategoryManagement.new(
        category: category,
        manager: moderators.sample
      )
    end
  end

  CategoryManagement.import(category_managements, on_duplicate_key_ignore: true)
end

seed :category_bannings do
  category_bannings = []

  Category.all.each do |category|
    users = User.where(role: :user)
    10.times do
      category_bannings << CategoryBanning.new(
        category: category,
        user: users.sample
      )
    end
  end

  CategoryBanning.import(category_bannings, on_duplicate_key_ignore: true)
end

seed :topics do
  topics = []
  first_posts = []

  Category.all.each do |category|
    users = users_can_interact_with_category(category)

    20.times do
      creator = users.sample

      first_post = category.posts.build(
        creator: creator,
        content: Faker::Lorem.paragraph(2, true)
      )

      topic = category.topics.build(
        name: "#{Faker::Football.player} #{SecureRandom.uuid}",
        status: :opening,
        creator: creator,
        first_post: first_post
      )

      first_posts << first_post
      topics << topic
    end
  end

  Post.import(first_posts, on_duplicate_key_ignore: true)
  Topic.import(topics, on_duplicate_key_ignore: true)
end

seed :posts do
  posts = []

  Topic.all.each do |topic|
    users = users_can_interact_with_category(topic.category)
    30.times do
      posts << topic.posts.build(
        category: topic.category,
        creator: users.sample,
        content: Faker::Lorem.paragraph(2, true)
      )
    end
  end

  Post.import(posts, on_duplicate_key_ignore: true)
end

seed :votings do
  votings = []

  Category.all.each do |category|
    users = users_can_interact_with_category(category)

    category.topics.each do |topic|
      topic.posts.each do |post|
        rand(5).times do
          votings << Voting.new(
            post: post,
            voter: users.sample,
            value: [-1, 1].sample
          )
        end
      end
    end
  end

  Voting.import(votings, on_duplicate_key_ignore: true)
end
