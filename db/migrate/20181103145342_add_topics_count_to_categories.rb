class AddTopicsCountToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :topics_count, :integer
  end
end
