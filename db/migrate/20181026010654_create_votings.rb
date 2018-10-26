class CreateVotings < ActiveRecord::Migration[5.2]
  def change
    create_table :votings do |t|
      t.belongs_to :voter, index: true
      t.belongs_to :votable, polymorphic: true, index: true
      t.integer :value

      t.timestamps
    end
  end
end
