class AddEntryReferenceToEntry < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :entry, type: :uuid, null: true
  end
end
