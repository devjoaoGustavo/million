class CreateDreams < ActiveRecord::Migration[5.1]
  def change
    create_table :dreams do |t|
      t.belongs_to :goal, type: :uuid, index: true
      t.belongs_to :user, type: :uuid, index: true

      t.timestamps
    end
  end
end
