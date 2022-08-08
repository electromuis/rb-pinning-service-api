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

ActiveRecord::Schema.define(version: 2022_03_02_215117) do

  create_table "pins", charset: "utf8mb4", force: :cascade do |t|
    t.string "cid", null: false
    t.string "name"
    t.text "origins", size: :long, collation: "utf8mb4_bin"
    t.text "meta", size: :long, collation: "utf8mb4_bin"
    t.string "status", default: "queued"
    t.text "delegates", size: :long, collation: "utf8mb4_bin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.integer "user_id", null: false
    t.bigint "storage_size"
    t.check_constraint "json_valid(`delegates`)", name: "delegates"
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`origins`)", name: "origins"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "access_token", null: false
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "storage_limit", default: 0
    t.bigint "used_storage", default: 0
  end

end
