class AddPostsCountToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :posts_count, :integer
  end
end
