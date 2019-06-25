class RemoveUserReferenceFromEntries < ActiveRecord::Migration[5.2]
  def change
    remove_column :entries, :user_id
  end
end
