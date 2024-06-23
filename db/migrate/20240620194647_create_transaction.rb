class CreateTransaction < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :source_currency, null: false
      t.string :target_currency, null: false
      t.decimal :source_amount, precision: 20, scale: 8, null: false
      t.decimal :target_amount, precision: 20, scale: 8, null: false
      t.decimal :exchange_rate, precision: 20, scale: 8, null: false
      t.references :client, null: false, foreign_key: true
      t.timestamps
    end
  end
end
