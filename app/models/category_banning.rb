class CategoryBanning < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :user, uniqueness: { scope: :category }
end
