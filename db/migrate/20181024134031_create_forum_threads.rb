class CreateForumThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :forum_threads do |t|
      t.belongs_to :creator, index: true
      t.belongs_to :category, index: true
      t.string :name
      t.integer :status
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
