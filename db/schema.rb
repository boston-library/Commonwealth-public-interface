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

ActiveRecord::Schema.define(version: 20141104185610) do

  create_table "batch_uploads", force: :cascade do |t|
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.string   "document_id",   limit: 255
    t.string   "title",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type",     limit: 255
    t.string   "document_type", limit: 255
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id"

  create_table "bpluser_folder_items", force: :cascade do |t|
    t.integer  "folder_id"
    t.string   "document_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bpluser_folder_items", ["document_id"], name: "index_bpluser_folder_items_on_document_id"
  add_index "bpluser_folder_items", ["folder_id"], name: "index_bpluser_folder_items_on_folder_id"

  create_table "bpluser_folders", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "user_id",                 null: false
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "visibility",  limit: 255
  end

  create_table "carousel_slides", force: :cascade do |t|
    t.integer  "sequence"
    t.string   "object_pid",  limit: 255
    t.string   "image_pid",   limit: 255
    t.string   "region"
    t.string   "title",       limit: 255
    t.string   "institution", limit: 255
    t.string   "context",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "size"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "pid",  limit: 255
  end

  create_table "institutions_users", id: false, force: :cascade do |t|
    t.integer "institution_id"
    t.integer "user_id"
  end

  add_index "institutions_users", ["institution_id", "user_id"], name: "index_institutions_users_on_institution_id_and_user_id"
  add_index "institutions_users", ["user_id", "institution_id"], name: "index_institutions_users_on_user_id_and_institution_id"

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id"

  create_table "searches", force: :cascade do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type",    limit: 255
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",                              default: false
    t.string   "username",               limit: 255
    t.string   "provider",               limit: 255
    t.string   "display_name",           limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider"

end
