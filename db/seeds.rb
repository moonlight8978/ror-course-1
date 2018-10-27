# Seed admin, moderator and users
p User.create!(
  email: 'admin@framgia.com',
  password: '1111',
  username: 'Admin depzai'
)

p User.create!(
  email: 'moderator@framgia.com',
  password: '1111',
  username: 'Moderator khoai to'
)

10.times do
  p User.create(
    email: Faker::Internet.email,
    username: Faker::Football.player,
    password: '1111',
    role: :moderator
  )
end

100.times do
  p User.create(
    email: Faker::Internet.email,
    username: Faker::Name.name,
    password: '1111'
  )
end

# Seed categories
10.times do
  p Category.create!(
    name: Faker::Football.unique.team
  )
end

# Seed category managements
Category.all.each do |category|
  moderators = User.where(role: :moderator)
  3.times do
    p CategoryManagement.create(
      category: category,
      manager: moderators.sample
    )
  end
end

# Seed category bannings
Category.all.each do |category|
  users = User.where(role: :user)
  10.times do
    p CategoryBanning.create(
      category: category,
      user: users.sample
    )
  end
end

def users_can_interact_with_category(category)
  banned_user_ids = CategoryBanning.select(:id).where(category: category)
    .map(&:id)
  User.where.not(id: banned_user_ids)
end

# Seed topics
Category.all.each do |category|
  users = users_can_interact_with_category(category)

  10.times do
    p category.topics.create!(
      name: "#{Faker::Football.competition} #{Faker::Dota.hero} #{Faker::Dota.team}",
      status: :opening,
      creator: users.sample
    )
  end
end

# Seed posts
Topic.all.each do |topic|
  users = users_can_interact_with_category(topic.category)
  10.times do
    p topic.posts.create!(
      creator: users.sample,
      content: Faker::Lorem.paragraph(2, true)
    )
  end
end

# Seed topic votings
Category.all.each do |category|
  users = users_can_interact_with_category(category)

  category.topics.each do |topic|
    rand(5).times do
      p Voting.create(
        votable: topic,
        voter: users.sample,
        value: [-1, 1].sample
      )
    end
  end
end

# Seed post votings
Category.all.each do |category|
  users = users_can_interact_with_category(category)

  category.topics.each do |topic|
    topic.posts.each do |post|
      rand(5).times do
        p Voting.create(
          votable: post,
          voter: users.sample,
          value: [-1, 1].sample
        )
      end
    end
  end
end
