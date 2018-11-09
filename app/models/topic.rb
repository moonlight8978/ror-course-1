class Topic < ApplicationRecord
  enum status: { opening: 0, locked: 5, deleted: 10 }

  # TODO: optimize counter cache
  belongs_to :category, counter_cache: true
  belongs_to :creator, class_name: 'User'

  has_one :last_post, -> { order(created_at: :desc) }, class_name: 'Post'

  has_many :posts
  has_many :votings, as: :votable

  has_many :voters, through: :votings

  validates :name, presence: true
  validates :status, presence: true, on: :update

  before_create :set_inital_status

  private

  def set_inital_status
    self.status ||= :opening
  end
end
