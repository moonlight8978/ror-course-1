class Topic < ApplicationRecord
  include SoftDeletable

  delegate :score, to: :first_post

  enum status: { opening: 0, locked: 5 }

  # TODO: optimize counter cache
  belongs_to :category, counter_cache: true
  belongs_to :creator, class_name: 'User'
  belongs_to :first_post, class_name: 'Post'

  has_one :last_post, -> { visible.order(created_at: :desc) },
    class_name: 'Post'

  has_many :posts

  validates :name, presence: true
  validates :status, presence: true, on: :update

  accepts_nested_attributes_for :first_post

  before_create :set_inital_status

  private

  def set_inital_status
    self.status ||= :opening
  end
end
