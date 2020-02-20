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

ActiveRecord::Schema.define(version: 2020_02_20_201940) do

  create_table "access_requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "request_token", null: false
    t.datetime "expires_at"
    t.datetime "granted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_token"], name: "index_access_requests_on_request_token", unique: true
    t.index ["user_id"], name: "index_access_requests_on_user_id"
  end

  create_table "access_tokens", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "access_request_id"
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

  create_table "clients", force: :cascade do |t|
    t.string "fingerprint", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fingerprint"], name: "index_clients_on_fingerprint", unique: true
  end

  create_table "page_views", id: :string, force: :cascade do |t|
    t.string "sid", null: false
    t.string "cid"
    t.string "host", null: false
    t.string "path", null: false
    t.string "referrer"
    t.boolean "analysed", default: false, null: false
    t.datetime "created_at"
  end

  create_table "sites", force: :cascade do |t|
    t.integer "creator_id"
    t.string "domain", null: false
    t.string "sid", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_sites_on_creator_id"
    t.index ["sid"], name: "index_sites_on_sid", unique: true
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

  add_foreign_key "access_requests", "users"
  add_foreign_key "access_tokens", "users"
  add_foreign_key "sites", "users", column: "creator_id"
end
