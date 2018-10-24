class Post < ApplicationRecord
  belongs_to :creator, class_name: User.name
  belongs_to :forum_thread

  has_many :post_votings

  has_many :voters, through: :post_votings
end
