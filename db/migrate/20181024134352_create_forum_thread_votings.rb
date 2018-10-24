class CreateForumThreadVotings < ActiveRecord::Migration[5.2]
  def change
    create_table :forum_thread_votings do |t|
      t.belongs_to :voter, index: true
      t.belongs_to :forum_thread, index: true
      t.integer :value

      t.timestamps
    end
  end
end
