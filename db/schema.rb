# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_23_050255) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_balances", force: :cascade do |t|
    t.string "currency_type"
    t.bigint "client_id", null: false
    t.decimal "amount", precision: 20, scale: 8, default: "200.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "currency_type"], name: "index_client_balances_on_client_id_and_currency_type", unique: true
    t.index ["client_id"], name: "index_client_balances_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "username", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_clients_on_username", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "source_currency", null: false
    t.string "target_currency", null: false
    t.decimal "source_amount", precision: 20, scale: 8, null: false
    t.decimal "target_amount", precision: 20, scale: 8, null: false
    t.decimal "exchange_rate", precision: 20, scale: 8, null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_transactions_on_client_id"
  end

  add_foreign_key "client_balances", "clients"
  add_foreign_key "transactions", "clients"
end
