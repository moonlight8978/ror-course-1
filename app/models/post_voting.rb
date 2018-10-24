class PostVoting < ApplicationRecord
  belongs_to :post
  belongs_to :voter, class_name: User.name
end
