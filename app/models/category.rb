class Category < ApplicationRecord
  has_many :category_managements
  has_many :category_bannings
  has_many :topics

  has_many :managers, through: :category_managements
  has_many :banned_users, through: :category_bannings, source: :user

  validates :name, presence: true, uniqueness: true
end
