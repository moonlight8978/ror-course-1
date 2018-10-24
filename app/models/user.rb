class User < ApplicationRecord
  has_many :category_managements, foreign_key: :manager_id
  has_many :category_bannings
  has_many :forum_threads
  has_many :forum_thread_votings
  has_many :posts
  has_many :post_votings

  has_many :managed_categories,
    through: :category_managements,
    source: :category
  has_many :banned_categories, through: :category_bannings, source: :category
  has_many :voted_forum_threads,
    through: :forum_thread_votings,
    source: :forum_thread
  has_many :voted_posts, through: :post_votings, source: :post
end
