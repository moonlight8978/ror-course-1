class Post < ApplicationRecord
  belongs_to :creator, class_name: User.name
  belongs_to :topic

  has_many :votings, as: :votable

  has_many :voters, through: :votings
end
