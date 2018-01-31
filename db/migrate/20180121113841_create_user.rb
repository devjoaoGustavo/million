class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :username
      t.string  :email,  null: false
      t.boolean :active, default: false
      t.string  :password_digest

      t.timestamps
    end
  end
end
