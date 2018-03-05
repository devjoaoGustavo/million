class AddEntryDateToEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :entry_date, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
