class CreateGoal < ActiveRecord::Migration[5.1]
  def change
    create_table :goals, id: :uuid do |t|
      t.string  :title,    null: false
      t.string  :description
      t.string  :status,   null: false, default: 'active'
      t.date    :deadline, null: false
      t.decimal :amount,   null: false
      t.decimal :reached,  null: false, default: 0.0

      t.timestamps
    end
  end
end
