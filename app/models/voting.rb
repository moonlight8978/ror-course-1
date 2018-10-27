class Voting < ApplicationRecord
  belongs_to :voter, class_name: 'User'
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :voter, uniqueness: { scope: %i[votable_id votable_type] }
end
