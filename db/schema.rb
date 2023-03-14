# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_23_162716) do

  create_table "admin_statistics", force: :cascade do |t|
    t.string "pid"
    t.integer "views"
    t.float "average_time"
    t.float "total_time"
    t.integer "exits"
    t.index ["pid"], name: "index_admin_statistics_on_pid", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "document_type"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "bpluser_folder_items", force: :cascade do |t|
    t.integer "folder_id"
    t.string "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["document_id"], name: "index_bpluser_folder_items_on_document_id"
    t.index ["folder_id"], name: "index_bpluser_folder_items_on_folder_id"
  end

  create_table "bpluser_folders", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "visibility"
    t.index ["user_id"], name: "index_bpluser_folders_on_user_id"
  end

  create_table "carousel_slides", force: :cascade do |t|
    t.integer "sequence"
    t.string "object_pid"
    t.string "image_pid"
    t.string "region"
    t.string "title"
    t.string "institution"
    t.string "context"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "size"
  end

  create_table "polaris_barcodes", force: :cascade do |t|
    t.string "barcodeID"
    t.integer "polaris_lookup_id"
    t.index ["barcodeID"], name: "index_polaris_barcodes_on_barcodeID", unique: true
    t.index ["polaris_lookup_id"], name: "index_polaris_barcodes_on_polaris_lookup_id"
  end

  create_table "polaris_lookups", force: :cascade do |t|
    t.string "itemID"
    t.string "bibID"
    t.string "horizonID"
    t.string "barcodeID"
    t.string "archiveID"
    t.index ["archiveID"], name: "index_polaris_lookups_on_archiveID"
    t.index ["barcodeID"], name: "index_polaris_lookups_on_barcodeID", unique: true
    t.index ["bibID"], name: "index_polaris_lookups_on_bibID", unique: true
    t.index ["horizonID"], name: "index_polaris_lookups_on_horizonID", unique: true
    t.index ["itemID"], name: "index_polaris_lookups_on_itemID", unique: true
  end

  create_table "searches", force: :cascade do |t|
    t.text "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "guest", default: false
    t.string "username"
    t.string "provider"
    t.string "display_name"
    t.string "first_name"
    t.string "last_name"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider"
  end

  add_foreign_key "bpluser_folder_items", "bpluser_folders", column: "folder_id"
  add_foreign_key "bpluser_folders", "users"
  add_foreign_key "polaris_barcodes", "polaris_lookups"
end
