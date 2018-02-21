class CreateEntryTag < ActiveRecord::Migration[5.1]
  def change
    create_table :entries_tags, id: :uuid do |t|
      t.references :entry, type: :uuid, foreign_key: true, null: false
      t.references :tag, type: :uuid, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
