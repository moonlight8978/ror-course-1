class User < ApplicationRecord
  has_secure_password

  has_many :category_managements, foreign_key: :manager_id
  has_many :category_bannings
  has_many :topics, foreign_key: :creator_id
  has_many :posts, foreign_key: :creator_id
  has_many :votings, foreign_key: :voter_id

  has_many :managed_categories,
    through: :category_managements, source: :category
  has_many :banned_categories, through: :category_bannings, source: :category
  has_many :voted_topics,
    through: :votings, source: :votable, source_type: Topic.name
  has_many :voted_posts,
    through: :votings, source: :votable, source_type: Post.name
end
