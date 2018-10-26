class CategoryManagement < ApplicationRecord
  belongs_to :manager, class_name: User.name
  belongs_to :category
end
