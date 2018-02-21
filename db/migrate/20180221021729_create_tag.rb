class CreateTag < ActiveRecord::Migration[5.1]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
