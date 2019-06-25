class RemoveActiveColumnFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :active
  end
end
