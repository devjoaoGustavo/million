class CreateSharings < ActiveRecord::Migration[5.2]
  def change
    create_table :sharings, id: :uuid do |t|
      t.references :wallet, type: :uuid, foreign_key: true
      t.references :user, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
