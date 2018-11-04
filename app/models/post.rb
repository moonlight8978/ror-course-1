class Post < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :topic
  # TODO: optimize counter cache
  belongs_to :category, counter_cache: true

  has_many :votings, as: :votable

  has_many :voters, through: :votings

  validates :content, presence: true
end
