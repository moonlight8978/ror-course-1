class FixVotings < ActiveRecord::Migration[5.2]
  def change
    remove_column :topics, :score
    drop_table :votings

    create_table :votings do |t|
      t.belongs_to :voter, index: true
      t.belongs_to :post, index: true
      t.integer :value

      t.timestamps
    end

    add_reference :topics, :first_post, index: true
  end
end
