# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151125060440) do

  create_table "checkout_table", force: :cascade do |t|
    t.datetime "time_opened"
    t.datetime "time_closed"
    t.integer  "equipment_id"
    t.integer  "users_id"
    t.integer  "request_status_id"
    t.integer  "request_types_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.integer  "status_id"
    t.string   "parts"
    t.integer  "users_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "description"
    t.integer  "equipment_type_id"
  end

  create_table "equipment_types", force: :cascade do |t|
    t.text "description"
  end

  create_table "notifications", force: :cascade do |t|
    t.text     "message"
    t.boolean  "viewed"
    t.datetime "timestamp"
    t.integer  "to_user_id"
    t.integer  "from_user_id"
  end

  create_table "positions", force: :cascade do |t|
    t.text     "title"
    t.integer  "users_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_statuses", force: :cascade do |t|
    t.string "status_desc", default: "0"
  end

  create_table "request_types", force: :cascade do |t|
    t.string "request_type_description"
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "status_desc"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "dues",                   default: false
    t.boolean  "waiver",                 default: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
