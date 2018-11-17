class Post < ApplicationRecord
  include SoftDeletable

  belongs_to :creator, class_name: 'User'
  # TODO: optimize counter cache
  belongs_to :topic, optional: true, counter_cache: true
  belongs_to :category, counter_cache: true

  has_many :votings

  has_many :voters, through: :votings

  validates :content, presence: true

  def first_post?
    topic.nil?
  end
end
