class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.belongs_to :creator, index: true
      t.belongs_to :forum_thread, index: true
      t.text :content
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
