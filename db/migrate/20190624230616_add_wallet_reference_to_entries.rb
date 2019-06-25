class AddWalletReferenceToEntries < ActiveRecord::Migration[5.2]
  def change
    add_reference :entries, :wallet, type: :uuid, foreign_key: true
  end
end
