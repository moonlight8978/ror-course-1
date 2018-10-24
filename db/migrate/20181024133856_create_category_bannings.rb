class CreateCategoryBannings < ActiveRecord::Migration[5.2]
  def change
    create_table :category_bannings do |t|
      t.belongs_to :user, index: true
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
