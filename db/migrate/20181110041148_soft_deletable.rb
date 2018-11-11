class SoftDeletable < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :deleted_at, :datetime, default: nil
    add_column :topics, :deleted_at, :datetime, default: nil
  end
end
