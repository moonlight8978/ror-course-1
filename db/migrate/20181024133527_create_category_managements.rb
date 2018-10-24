class CreateCategoryManagements < ActiveRecord::Migration[5.2]
  def change
    create_table :category_managements do |t|
      t.belongs_to :manager, index: true
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
