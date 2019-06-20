class CreateCategory < ActiveRecord::Migration[5.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
