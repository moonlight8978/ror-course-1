class Voting < ApplicationRecord
  belongs_to :voter, class_name: 'User'
  belongs_to :post

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :voter, uniqueness: { scope: :post }
end
