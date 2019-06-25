class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets, id: :uuid do |t|
      t.string :name, null: false, default: 'Carteira principal'
      t.string :icon, null: false, default: 'icons/wallet_icon.svg'
      t.boolean :default, null: false, default: false
      t.references :user, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
