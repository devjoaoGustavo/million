class CreateEntry < ActiveRecord::Migration[5.1]
  def change
    create_table :entries, id: :uuid do |t|
      t.string :description
      t.string :type, null: false
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :category, type: :uuid, foreign_key: true, null: false
      t.references :entry, type: :uuid
      t.references :goal, type: :uuid
      t.decimal :amount, null: false
      t.datetime :entry_date, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps null: false
    end
  end
end
