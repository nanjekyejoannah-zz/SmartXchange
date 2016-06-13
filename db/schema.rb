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

ActiveRecord::Schema.define(version: 20160611150011) do

  create_table "chats", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "chats", ["created_at"], name: "index_chats_on_created_at"
  add_index "chats", ["recipient_id"], name: "index_chats_on_recipient_id"
  add_index "chats", ["sender_id"], name: "index_chats_on_sender_id"

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "chat_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "messages", ["chat_id", "created_at"], name: "index_messages_on_chat_id_and_created_at"
  add_index "messages", ["chat_id"], name: "index_messages_on_chat_id"
  add_index "messages", ["created_at"], name: "index_messages_on_created_at"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                                      null: false
    t.string   "name",            default: "User",           null: false
    t.integer  "age",             default: 25,               null: false
    t.string   "language",        default: "Spanish",        null: false
    t.integer  "language_level",  default: 5,                null: false
    t.string   "password_digest",                            null: false
    t.string   "session_token",                              null: false
    t.string   "image"
    t.boolean  "active",          default: false,            null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "title",           default: "Baller at Life", null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["session_token"], name: "index_users_on_session_token"

end
