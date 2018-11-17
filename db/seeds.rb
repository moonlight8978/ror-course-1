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

def random(max, count)
  Array.new(count).map { rand(max) }
end

def get_quantity(model)
  quantities = {
    development: {
      user: 100,
      category: 20,
      banning: 10,
      topic: 20,
      post: 30,
      voting: rand(5),
      locked_topic: rand(10..15),
      deleted_topic: rand(20..30),
      deleted_post: rand(500..600)
    },
    production: {
      user: 30,
      category: 7,
      banning: 4,
      topic: 20,
      post: 5,
      voting: rand(3),
      locked_topic: 10,
      deleted_topic: 10,
      deleted_post: 50
    }
  }

  if Rails.env.development?
    quantities.dig(:development, model)
  elsif Rails.env.production?
    quantities.dig(:production, model)
  else
    raise StandardError
  end
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

  users << User.new(
    email: 'user@framgia.com',
    password: '1111',
    username: 'super super admin'
  )

  10.times do
    users << User.new(
      email: "#{SecureRandom.hex(10)}_#{Faker::Internet.email}",
      username: "#{Faker::Dota.player} #{SecureRandom.hex(10)}",
      password: '1111',
      role: :moderator
    )
  end

  get_quantity(:user).times do
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

  get_quantity(:category).times do
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
    get_quantity(:banning).times do
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

    get_quantity(:topic).times do
      creator = users.sample

      first_post = category.posts.build(
        creator: creator,
        content: Faker::Lorem.paragraph(3, true, 30)
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
    get_quantity(:post).times do
      posts << topic.posts.build(
        category: topic.category,
        creator: users.sample,
        content: Faker::Lorem.paragraph(3, true, 30)
      )
    end
  end

  Post.import(posts, on_duplicate_key_ignore: true)
end

seed :votings do
  votings = []

  Category.all.each do |category|
    users = users_can_interact_with_category(category)

    category.posts.each do |post|
      get_quantity(:voting).times do
        votings << Voting.new(
          post: post,
          voter: users.sample,
          value: [-1, 1].sample
        )
      end
    end
  end

  Voting.import(votings, on_duplicate_key_ignore: true)
end

seed :locked_topics do
  locked_topic_ids = random(Topic.count, get_quantity(:locked_topic))
  locked_topics = Topic.where(id: locked_topic_ids)
  locked_topics = locked_topics.map do |topic|
    topic.tap { topic.status = :locked }
  end

  Topic.import(locked_topics, on_duplicate_key_update: [:status])
end

seed :deleted_topics do
  deleted_topic_ids = random(Topic.count, get_quantity(:deleted_topic))
  deleted_topics = Topic.where(id: deleted_topic_ids, status: :opening)
  deleted_topics = deleted_topics.map do |topic|
    topic.tap { topic.deleted_at = Time.current }
  end

  Topic.import(deleted_topics, on_duplicate_key_update: [:deleted_at])
end

seed :deleted_posts do
  deleted_post_ids = random(Post.count, get_quantity(:deleted_post))
  deleted_posts = Post.where(id: deleted_post_ids)
  deleted_posts = deleted_posts.map do |post|
    post.tap { post.deleted_at = Time.current }
  end

  Post.import(deleted_posts, on_duplicate_key_update: [:deleted_at])
end
