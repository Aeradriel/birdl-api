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

ActiveRecord::Schema.define(version: 20160114160505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "progression", default: 0
  end

  create_table "addresses", force: :cascade do |t|
    t.integer  "num"
    t.string   "street",     limit: 255
    t.string   "zipcode",    limit: 255
    t.string   "city",       limit: 255
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "addresses", ["country_id"], name: "index_addresses_on_country_id", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", null: false
    t.integer  "user_id",      null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "badges", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.string   "icon_path",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identifier",  limit: 255
  end

  create_table "countries", force: :cascade do |t|
    t.string   "language",   limit: 255
    t.string   "flag_path",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255, default: ""
    t.boolean  "available",              default: false
    t.string   "i18n_key",   limit: 255
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "type",       limit: 255
    t.integer  "min_slots"
    t.integer  "max_slots"
    t.datetime "date"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "desc",       limit: 255
    t.integer  "owner_id"
    t.integer  "address_id"
    t.string   "language",   limit: 255
    t.string   "location",   limit: 255
  end

  add_index "events", ["address_id"], name: "index_events_on_address_id", using: :btree
  add_index "events", ["owner_id"], name: "index_events_on_owner_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "object",      limit: 255
    t.string   "content",     limit: 255
    t.boolean  "sent",                    default: false
    t.date     "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",                    default: false
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "text",       default: ""
    t.string   "subject",    default: ""
    t.boolean  "seen",       default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "participations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.boolean "was_there"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "giver_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "value"
    t.text     "comment"
    t.integer  "event_id"
  end

  add_index "ratings", ["event_id"], name: "index_ratings_on_event_id", using: :btree
  add_index "ratings", ["giver_id"], name: "index_ratings_on_giver_id", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "relations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "relations", ["friend_id"], name: "index_relations_on_friend_id", using: :btree
  add_index "relations", ["user_id"], name: "index_relations_on_user_id", using: :btree

  create_table "user_ratings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "giver_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_ratings", ["giver_id"], name: "index_user_ratings_on_giver_id", using: :btree
  add_index "user_ratings", ["user_id"], name: "index_user_ratings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.date     "birthdate"
    t.integer  "gender",                             default: 1
    t.boolean  "admin",                              default: false
    t.integer  "country_id"
    t.string   "locale",                 limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.boolean  "fb_acc",                             default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "notifications", "users"
end
