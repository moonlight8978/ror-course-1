class Category < ApplicationRecord
  has_many :category_managements
  has_many :category_bannings
  has_many :forum_threads

  has_many :managers, through: :category_managements
  has_many :banned_users, through: :category_bannings, source: :user
end
