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

ActiveRecord::Schema.define(version: 20160923035630) do

  create_table "basic_profiles", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "maiden_name"
    t.string   "formatted_name"
    t.string   "headline"
    t.string   "location"
    t.string   "industry"
    t.string   "summary"
    t.string   "specialties"
    t.string   "picture_url"
    t.string   "public_profile_url"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "boards", force: :cascade do |t|
    t.string   "title",       null: false
    t.text     "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "initiator_id"
    t.integer  "recipient_id"
    t.index ["initiator_id"], name: "index_chat_rooms_on_initiator_id"
    t.index ["recipient_id"], name: "index_chat_rooms_on_recipient_id"
    t.index ["updated_at"], name: "index_chat_rooms_on_updated_at"
  end

  create_table "chats", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["created_at"], name: "index_chats_on_created_at"
    t.index ["recipient_id"], name: "index_chats_on_recipient_id"
    t.index ["sender_id"], name: "index_chats_on_sender_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content",          null: false
    t.integer  "owner_id",         null: false
    t.string   "commentable_type", null: false
    t.integer  "commentable_id",   null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["created_at"], name: "index_comments_on_created_at"
    t.index ["owner_id"], name: "index_comments_on_owner_id"
  end

  create_table "educations", force: :cascade do |t|
    t.string   "school_name"
    t.string   "field_of_study"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "degree"
    t.string   "activities"
    t.string   "notes"
    t.integer  "full_profile_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable_type_and_followable_id"
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "full_profiles", force: :cascade do |t|
    t.string   "associations"
    t.string   "honors"
    t.string   "interests"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "linkedin_oauth_settings", force: :cascade do |t|
    t.string   "atoken"
    t.string   "asecret"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "linkedins", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "public_url"
    t.string   "industry"
    t.string   "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_linkedins_on_user_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "sender_id"
    t.integer  "chat_room_id"
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id"
    t.index ["created_at"], name: "index_messages_on_created_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean  "read",            default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "notified_id"
    t.integer  "notifier_id"
    t.string   "notifiable_type"
    t.integer  "notifiable_id"
    t.string   "sourceable_type"
    t.integer  "sourceable_id"
    t.index ["created_at"], name: "index_notifications_on_created_at"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["notifiable_type"], name: "index_notifications_on_notifiable_type"
    t.index ["notified_id"], name: "index_notifications_on_notified_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string   "title"
    t.string   "summary"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "is_current"
    t.string   "company"
    t.integer  "full_profile_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "posts", force: :cascade do |t|
    t.text     "content",    null: false
    t.integer  "owner_id",   null: false
    t.integer  "board_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_posts_on_owner_id"
    t.index ["updated_at"], name: "index_posts_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                                      null: false
    t.string   "name",            default: "New User",                       null: false
    t.integer  "age",             default: 25,                               null: false
    t.string   "language",        default: "Spanish",                        null: false
    t.integer  "language_level",  default: 3,                                null: false
    t.string   "password_digest",                                            null: false
    t.string   "session_token",                                              null: false
    t.string   "image"
    t.boolean  "active",          default: false,                            null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "title",           default: "Please fill in your profession", null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "nationality"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["session_token"], name: "index_users_on_session_token"
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "value",        limit: 1, null: false
    t.string   "votable_type",           null: false
    t.integer  "votable_id",             null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "owner_id"
    t.index ["owner_id"], name: "index_votes_on_owner_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
  end

end
