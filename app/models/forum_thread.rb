class ForumThread < ApplicationRecord
  belongs_to :category
  belongs_to :creator, class_name: User.name

  has_many :forum_thread_votings
  has_many :posts

  has_many :voters, through: :forum_thread_votings
end
