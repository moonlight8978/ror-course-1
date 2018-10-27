class User < ApplicationRecord
  has_secure_password

  enum status: { offline: 0, online: 1 }
  enum role: { user: 10, moderator: 50, admin: 100 }

  has_many :category_managements, foreign_key: :manager_id
  has_many :category_bannings
  has_many :topics, foreign_key: :creator_id
  has_many :posts, foreign_key: :creator_id
  has_many :votings, foreign_key: :voter_id

  has_many :managed_categories,
    through: :category_managements, source: :category
  has_many :banned_categories, through: :category_bannings, source: :category
  has_many :voted_topics,
    through: :votings, source: :votable, source_type: 'Topic'
  has_many :voted_posts,
    through: :votings, source: :votable, source_type: 'Post'

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, on: :update

  before_create :set_default_role

  class << self
    def authenticate(login_params)
      user = new(login_params)
      persisted_user = find_by_email(user.email)
      return user.tap { user.errors.add(:email, :wrong) } unless persisted_user
      return persisted_user if persisted_user.authenticate(user.password)

      user.tap { user.errors.add(:password, :wrong) }
    end
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
