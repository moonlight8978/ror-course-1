class Voting < ApplicationRecord
  belongs_to :voter, class_name: User.name
  belongs_to :votable, polymorphic: true
end
