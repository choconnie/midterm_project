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

ActiveRecord::Schema.define(version: 20160201013201) do

  create_table "announcements", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id"

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "title"
    t.date     "event_date"
    t.string   "location"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "details"
  end

  add_index "events", ["post_id"], name: "index_events_on_post_id"

  create_table "groups", force: :cascade do |t|
    t.string   "group_name"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "user_id"
    t.boolean  "status",      default: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "photos", force: :cascade do |t|
    t.string  "description"
    t.string  "content_type"
    t.string  "filename"
    t.string  "url"
    t.integer "user_id"
  end

  create_table "post_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "title"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["group_id"], name: "index_posts_on_group_id"

  create_table "service_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.boolean  "status",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",           default: false
    t.string   "avatar_name",     default: "avatar.png"
  end

end
