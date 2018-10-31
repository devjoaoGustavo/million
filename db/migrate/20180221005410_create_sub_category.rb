class CreateSubCategory < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_categories, id: :uuid do |t|
      t.string :name, null: false
      t.references :category, type: :uuid, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
