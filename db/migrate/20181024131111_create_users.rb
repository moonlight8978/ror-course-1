class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email, index: true
      t.string :password_digest
      t.integer :role
      t.integer :status

      t.timestamps
    end
  end
end
