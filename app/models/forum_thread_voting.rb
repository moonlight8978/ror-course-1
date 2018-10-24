class ForumThreadVoting < ApplicationRecord
  belongs_to :voter, class_name: User.name
  belongs_to :forum_thread
end
