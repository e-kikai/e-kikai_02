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

ActiveRecord::Schema.define(version: 20150608090803) do

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "company_kana"
    t.string   "representative"
    t.string   "officer"
    t.string   "tel"
    t.string   "fax"
    t.string   "mail"
    t.string   "zip"
    t.string   "addr1"
    t.string   "addr2"
    t.string   "addr3"
    t.string   "contact_tel"
    t.string   "contact_fax"
    t.string   "contact_mail"
    t.string   "website"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deleted_at"
    t.integer  "machinelife_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "officer"
    t.string   "mail",       null: false
    t.string   "tel"
    t.text     "content",    null: false
    t.integer  "company_id"
    t.integer  "machine_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contacts", ["company_id"], name: "index_contacts_on_company_id"
  add_index "contacts", ["machine_id"], name: "index_contacts_on_machine_id"

  create_table "genres", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "capacity_label"
    t.string   "capacity_unit"
    t.integer  "order_no"
    t.integer  "middle_genre_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "machinelife_id"
  end

  add_index "genres", ["middle_genre_id"], name: "index_genres_on_middle_genre_id"

  create_table "images", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "img_uid"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "img_name"
  end

  create_table "large_genres", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "order_no"
    t.datetime "deleted_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "machinelife_id"
  end

  create_table "machines", force: :cascade do |t|
    t.string   "no"
    t.string   "name",               null: false
    t.string   "maker"
    t.string   "model"
    t.string   "year"
    t.float    "capacity"
    t.string   "location"
    t.string   "addr1"
    t.string   "addr2"
    t.string   "addr3"
    t.text     "spec"
    t.text     "accessory"
    t.text     "comment"
    t.integer  "commission"
    t.integer  "genre_id",           null: false
    t.integer  "company_id",         null: false
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "machinelife_id"
    t.text     "machinelife_images"
  end

  add_index "machines", ["addr1"], name: "index_machines_on_addr1"
  add_index "machines", ["company_id"], name: "index_machines_on_company_id"
  add_index "machines", ["created_at"], name: "index_machines_on_created_at"
  add_index "machines", ["deleted_at"], name: "index_machines_on_deleted_at"
  add_index "machines", ["genre_id"], name: "index_machines_on_genre_id"

  create_table "middle_genres", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "order_no"
    t.integer  "large_genre_id"
    t.datetime "deleted_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "machinelife_id"
  end

  add_index "middle_genres", ["large_genre_id"], name: "index_middle_genres_on_large_genre_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "company_id"
    t.string   "username"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
