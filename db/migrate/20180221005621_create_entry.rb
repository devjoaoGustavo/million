class CreateEntry < ActiveRecord::Migration[5.1]
  def change
    create_table :entries, id: :uuid do |t|
      t.string :description
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :category, type: :uuid, foreign_key: true, null: false
      t.string :kind, null: false
      t.decimal :amount, null: false

      t.timestamps null: false
    end
  end
end
