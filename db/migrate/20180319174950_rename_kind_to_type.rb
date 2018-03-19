class RenameKindToType < ActiveRecord::Migration[5.1]
  def change
    change_table :entries do |t|
      t.rename :kind, :type
    end
  end
end
