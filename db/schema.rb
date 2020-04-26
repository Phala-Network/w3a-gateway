# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_13_105722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "request_token", null: false
    t.datetime "expires_at"
    t.datetime "granted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_token"], name: "index_access_requests_on_request_token", unique: true
    t.index ["user_id"], name: "index_access_requests_on_user_id"
  end

  create_table "access_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "access_request_id"
    t.string "token", null: false
    t.string "refresh_token", null: false
    t.datetime "expires_at"
    t.datetime "revoked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["access_request_id"], name: "index_access_tokens_on_access_request_id"
    t.index ["refresh_token"], name: "index_access_tokens_on_refresh_token", unique: true
    t.index ["token"], name: "index_access_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "client_contracts", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.bigint "client_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_client_contracts_on_client_id"
    t.index ["contract_id"], name: "index_client_contracts_on_contract_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "fingerprint", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fingerprint"], name: "index_clients_on_fingerprint", unique: true
  end

  create_table "contract_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_subscriptions", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.bigint "site_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_id", "site_id"], name: "index_contract_subscriptions_on_contract_id_and_site_id", unique: true
    t.index ["contract_id"], name: "index_contract_subscriptions_on_contract_id"
    t.index ["site_id"], name: "index_contract_subscriptions_on_site_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "agreement"
    t.boolean "builtin", default: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "script", default: ""
    t.index ["group_id"], name: "index_contracts_on_group_id"
  end

  create_table "daily_stats_reports", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.integer "pv_count", null: false
    t.integer "clients_count", null: false
    t.integer "avg_duration_in_seconds", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id"], name: "index_daily_stats_reports_on_site_id"
  end

  create_table "hourly_stats_reports", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.integer "pv_count", null: false
    t.integer "clients_count", null: false
    t.integer "avg_duration_in_seconds", null: false
    t.datetime "timestamp", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id"], name: "index_hourly_stats_reports_on_site_id"
  end

  create_table "key_values", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value_type", null: false
    t.integer "integer_value"
    t.datetime "datetime_value"
    t.string "string_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key"], name: "index_key_values_on_key", unique: true
  end

  create_table "online_users_reports", force: :cascade do |t|
    t.bigint "site_id"
    t.integer "unique_cid_count", null: false
    t.integer "unique_ip_count", null: false
    t.integer "week_on_week", default: 0
    t.integer "day_to_day", default: 0
    t.datetime "timestamp", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id"], name: "index_online_users_reports_on_site_id"
  end

  create_table "page_views", id: :string, force: :cascade do |t|
    t.string "sid", null: false
    t.string "cid"
    t.string "host", null: false
    t.string "path", null: false
    t.string "referrer"
    t.string "ip"
    t.string "ua"
    t.boolean "analysed", default: false, null: false
    t.datetime "created_at"
  end

  create_table "site_clients", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.string "cid"
    t.datetime "created_at"
    t.index ["site_id", "cid"], name: "index_site_clients_on_site_id_and_cid", unique: true
    t.index ["site_id"], name: "index_site_clients_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "domain", null: false
    t.string "sid", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "description"
    t.string "phala_address"
    t.index ["creator_id"], name: "index_sites_on_creator_id"
    t.index ["sid"], name: "index_sites_on_sid", unique: true
  end

  create_table "total_stats_reports", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.integer "clients_count", null: false
    t.integer "pv_count", null: false
    t.integer "avg_duration_in_seconds", null: false
    t.datetime "timestamp", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id"], name: "index_total_stats_reports_on_site_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "public_key", null: false
    t.datetime "disabled_at"
    t.datetime "activated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["public_key"], name: "index_users_on_public_key", unique: true
  end

  create_table "weekly_clients", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.string "cid"
    t.date "date"
    t.datetime "created_at"
    t.index ["site_id", "cid", "date"], name: "index_weekly_clients_on_site_id_and_cid_and_date", unique: true
    t.index ["site_id"], name: "index_weekly_clients_on_site_id"
  end

  create_table "weekly_devices", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.string "device"
    t.integer "count"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id", "device", "date"], name: "index_weekly_devices_on_site_id_and_device_and_date", unique: true
    t.index ["site_id"], name: "index_weekly_devices_on_site_id"
  end

  create_table "weekly_sites_reports", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.string "path", null: false
    t.integer "count", default: 0, null: false
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id"], name: "index_weekly_sites_reports_on_site_id"
  end

  add_foreign_key "access_requests", "users"
  add_foreign_key "access_tokens", "users"
  add_foreign_key "client_contracts", "clients"
  add_foreign_key "client_contracts", "contracts"
  add_foreign_key "contract_subscriptions", "contracts"
  add_foreign_key "contract_subscriptions", "sites"
  add_foreign_key "contracts", "contract_groups", column: "group_id"
  add_foreign_key "sites", "users", column: "creator_id"
  add_foreign_key "weekly_devices", "sites"
end
