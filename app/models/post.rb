class Post < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :topic, optional: true
  # TODO: optimize counter cache
  belongs_to :category, counter_cache: true

  has_many :votings

  has_many :voters, through: :votings

  validates :content, presence: true
  validates :topic, presence: { if: :first_post? }, on: :create

  def first_post?
    Topic.exists?(first_post: self)
  end
end
