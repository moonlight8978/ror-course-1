class Topic < ApplicationRecord
  belongs_to :category
  belongs_to :creator, class_name: User.name

  has_many :posts
  has_many :votings, as: :votable

  has_many :voters, through: :votings
end
