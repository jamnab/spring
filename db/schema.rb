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

ActiveRecord::Schema.define(version: 20150422181212) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.boolean  "read",           default: false
    t.boolean  "collected",      default: false
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.boolean  "endorsed",         default: false
    t.boolean  "anonymous",        default: false
    t.boolean  "suggestion",       default: false
    t.integer  "opinion",          default: 0
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "department_entries", force: true do |t|
    t.integer  "context_id"
    t.string   "context_type"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_notification_settings", force: true do |t|
    t.string   "settings_for"
    t.integer  "timed_task_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "email_notification_settings", ["timed_task_id"], name: "index_email_notification_settings_on_timed_task_id", using: :btree
  add_index "email_notification_settings", ["user_id"], name: "index_email_notification_settings_on_user_id", using: :btree

  create_table "favourites", force: true do |t|
    t.integer  "user_id"
    t.integer  "fav_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "label_entries", force: true do |t|
    t.integer  "tag_id"
    t.integer  "labelable_id"
    t.string   "labelable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "opinions", force: true do |t|
    t.boolean  "positive",         default: true
    t.integer  "opinionable_id"
    t.string   "opinionable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_memberships", force: true do |t|
    t.boolean  "admin",           default: false
    t.integer  "organization_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "access_token"
    t.boolean  "activated",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_handle"
    t.string   "twitter_widget_id"
    t.string   "facebook_page_handle"
  end

  create_table "pictures", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "anonymous",         default: true
    t.integer  "threshold",         default: 20
    t.integer  "opinion",           default: 0
    t.integer  "user_id"
    t.integer  "organization_id"
    t.integer  "post_type"
    t.boolean  "graveyard",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "comment_anonymity", default: false
    t.integer  "comments_count",    default: 0
    t.boolean  "approved",          default: false
  end

  create_table "project_memberships", force: true do |t|
    t.boolean  "admin",      default: false
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "access_code"
    t.integer  "threshold"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.string   "email"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_entries", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timed_tasks", force: true do |t|
    t.integer  "interval"
    t.string   "measure_of_time"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.integer  "organization_id"
    t.boolean  "manager",           default: false
    t.boolean  "admin",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
