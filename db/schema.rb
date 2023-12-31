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

ActiveRecord::Schema[7.0].define(version: 2023_07_20_220830) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description", null: false
    t.string "client_code", limit: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_code"], name: "index_clients_on_client_code", unique: true
  end

  create_table "configurations", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "provider", default: "google_oauth2", null: false
    t.string "default_scope", default: "email username profile", null: false
    t.jsonb "custom_fields", default: {}, null: false
    t.string "redirect_uri", null: false
    t.string "domain", null: false
    t.string "audience", null: false
    t.string "client_key_frontend", null: false
    t.string "client_secret_frontend", null: false
    t.string "client_key", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_configurations_on_client_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description", null: false
    t.integer "role_type", default: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "tokens", force: :cascade do |t|
    t.string "authentication_token", null: false
    t.datetime "invalidated_at", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "client_id", default: 1, null: false
    t.bigint "role_id", default: 3, null: false
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.jsonb "custom_fields", default: {}, null: false
    t.string "username", limit: 30, null: false
    t.string "email", limit: 100, null: false
    t.string "omniauth_provider", limit: 120
    t.string "uid", limit: 120
    t.string "encrypted_password", limit: 120, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_users_on_client_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "configurations", "clients"
  add_foreign_key "tokens", "users"
  add_foreign_key "users", "clients"
  add_foreign_key "users", "roles"
end
