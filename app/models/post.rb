class Post < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :topic
  belongs_to :category

  has_many :votings, as: :votable

  has_many :voters, through: :votings

  validates :content, presence: true
end
