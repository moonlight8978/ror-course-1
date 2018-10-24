class CreatePostVotings < ActiveRecord::Migration[5.2]
  def change
    create_table :post_votings do |t|
      t.belongs_to :voter, index: true
      t.belongs_to :post, index: true
      t.integer :value

      t.timestamps
    end
  end
end
