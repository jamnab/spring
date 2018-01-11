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

ActiveRecord::Schema.define(version: 20160826065239) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.boolean  "read",                         default: false
    t.boolean  "collected",                    default: false
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "assets", force: :cascade do |t|
    t.integer  "post_id",               limit: 4
    t.boolean  "private",                           default: true
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
  end

  create_table "beta_sign_ups", force: :cascade do |t|
    t.string   "email",          limit: 255
    t.string   "first_name",     limit: 255
    t.string   "last_name",      limit: 255
    t.string   "workflow_state", limit: 255
    t.string   "signup_code",    limit: 255
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content",          limit: 65535
    t.boolean  "endorsed",                       default: false
    t.boolean  "anonymous",                      default: false
    t.boolean  "suggestion",                     default: false
    t.integer  "opinion",          limit: 4,     default: 0
    t.integer  "user_id",          limit: 4
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "department_entries", force: :cascade do |t|
    t.integer  "context_id",        limit: 4
    t.string   "context_type",      limit: 255
    t.integer  "department_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "department_name",   limit: 255
    t.string   "abbrev_name",       limit: 255
    t.boolean  "approval_required",             default: false
  end

  create_table "department_entry_memberships", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "department_entry_id", limit: 4
    t.boolean  "admin",                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_notification_settings", force: :cascade do |t|
    t.string   "settings_for",  limit: 255
    t.integer  "timed_task_id", limit: 4
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "email_notification_settings", ["timed_task_id"], name: "index_email_notification_settings_on_timed_task_id", using: :btree
  add_index "email_notification_settings", ["user_id"], name: "index_email_notification_settings_on_user_id", using: :btree

  create_table "favourites", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "fav_post_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "label_entries", force: :cascade do |t|
    t.integer  "tag_id",         limit: 4
    t.integer  "labelable_id",   limit: 4
    t.string   "labelable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "labels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "activity_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "to_compile",            default: false
  end

  create_table "opinions", force: :cascade do |t|
    t.boolean  "positive",                     default: true
    t.integer  "opinionable_id",   limit: 4
    t.string   "opinionable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.boolean  "admin",                     default: false
    t.integer  "organization_id", limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "access_token",         limit: 255
    t.boolean  "activated",                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_handle",       limit: 255
    t.string   "twitter_widget_id",    limit: 255
    t.string   "facebook_page_handle", limit: 255
  end

  create_table "pictures", force: :cascade do |t|
    t.integer  "post_id",            limit: 4
    t.integer  "user_id",            limit: 4
    t.integer  "organization_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "post_department_entries", force: :cascade do |t|
    t.string   "department_entry_id", limit: 255
    t.integer  "post_id",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",                        default: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.text     "content",           limit: 65535
    t.boolean  "anonymous",                       default: true
    t.integer  "opinion",           limit: 4,     default: 0
    t.integer  "user_id",           limit: 4
    t.integer  "organization_id",   limit: 4
    t.boolean  "graveyard",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "comment_anonymity",               default: false
    t.integer  "comments_count",    limit: 4,     default: 0
    t.boolean  "approved",                        default: false
    t.date     "action_date"
    t.boolean  "launch_approved",                 default: false
    t.boolean  "launched",                        default: false
  end

  create_table "project_memberships", force: :cascade do |t|
    t.boolean  "admin",                default: false
    t.integer  "project_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "access_code",     limit: 255
    t.integer  "threshold",       limit: 4
    t.integer  "organization_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",   limit: 4
    t.string   "subscription_type", limit: 255
    t.datetime "end_at"
    t.boolean  "active"
  end

  create_table "tag_entries", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "organization_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timed_tasks", force: :cascade do |t|
    t.integer  "interval",        limit: 4
    t.string   "measure_of_time", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "user_invites", force: :cascade do |t|
    t.string   "email",               limit: 255
    t.integer  "department_entry_id", limit: 4
    t.boolean  "admin",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id",     limit: 4
    t.integer  "user_id",             limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",                limit: 255
    t.string   "email",                   limit: 255
    t.string   "crypted_password",        limit: 255
    t.string   "password_salt",           limit: 255
    t.string   "persistence_token",       limit: 255
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "job_title",               limit: 255
    t.integer  "organization_id",         limit: 4
    t.boolean  "manager",                             default: false
    t.boolean  "admin",                               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribe_to_newsletter",             default: false
    t.string   "notification_settings",   limit: 255, default: "210011211"
  end

end
