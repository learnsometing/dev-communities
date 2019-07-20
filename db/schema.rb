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

ActiveRecord::Schema.define(version: 2019_07_20_170551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friend_requests", force: :cascade do |t|
    t.integer "friend_id"
    t.integer "requestor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted", default: false
    t.index ["friend_id"], name: "index_friend_requests_on_friend_id"
    t.index ["requestor_id", "friend_id"], name: "index_friend_requests_on_requestor_id_and_friend_id", unique: true
    t.index ["requestor_id"], name: "index_friend_requests_on_requestor_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "friend_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friendships_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friendships_on_user_id"
  end

  create_table "notification_changes", force: :cascade do |t|
    t.bigint "notification_object_id"
    t.bigint "actor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["actor_id"], name: "index_notification_changes_on_actor_id"
    t.index ["notification_object_id", "actor_id"], name: "notification_change_data"
    t.index ["notification_object_id"], name: "index_notification_changes_on_notification_object_id"
  end

  create_table "notification_objects", force: :cascade do |t|
    t.string "notification_triggerable_type"
    t.bigint "notification_triggerable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_triggerable_type", "notification_triggerable_id"], name: "notification_trigger_data", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "notification_object_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_object_id"], name: "index_notifications_on_notification_object_id"
    t.index ["user_id", "notification_object_id"], name: "notification_data"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.index ["author_id"], name: "index_posts_on_author_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "profile_picture"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "notification_changes", "notification_objects"
  add_foreign_key "notification_changes", "users", column: "actor_id"
  add_foreign_key "notifications", "notification_objects"
  add_foreign_key "notifications", "users"
end
