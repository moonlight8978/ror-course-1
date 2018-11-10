class AddPostsCountToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :posts_count, :integer
  end
end
