class CategoryManagement < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  belongs_to :category

  validates :manager, uniqueness: { scope: :category }
end
