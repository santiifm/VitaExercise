class CreateClientBalance < ActiveRecord::Migration[7.1]
  def change
    create_table :client_balances do |t|
      t.string :currency_type
      t.references :client, null: false, foreign_key: true
      t.decimal :amount, precision: 20, scale: 8, null: false, default: 200.0
      t.timestamps
    end

    add_index :client_balances, [:client_id, :currency_type], unique: true
  end
end
