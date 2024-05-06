# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_05_06_204646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "givenname", default: "", null: false
    t.string "surname", default: "", null: false
    t.string "initials", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "approver", default: false
    t.jsonb "groups", default: [], null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true, null: false
    t.index ["title"], name: "index_clients_on_title", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "description"
    t.string "vendor_reference"
    t.integer "quantity"
    t.float "price"
    t.bigint "request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "received_by_id"
    t.datetime "received_at"
    t.string "link", default: "", null: false
    t.datetime "returned_at"
    t.bigint "returned_by_id"
    t.string "reason_for_rejection", default: ""
    t.float "refund"
    t.index ["received_by_id"], name: "index_items_on_received_by_id"
    t.index ["request_id"], name: "index_items_on_request_id"
    t.index ["returned_by_id"], name: "index_items_on_returned_by_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.integer "identifier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true, null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_projects_on_client_id"
    t.index ["identifier"], name: "index_projects_on_identifier", unique: true
  end

  create_table "requests", force: :cascade do |t|
    t.text "notes", default: "", null: false
    t.text "reason_for_rejection", default: "", null: false
    t.float "shipping_cost", default: 0.0, null: false
    t.float "sales_tax", default: 0.0, null: false
    t.float "import_tax", default: 0.0, null: false
    t.datetime "date_received"
    t.datetime "date_approved"
    t.datetime "date_ordered"
    t.string "order_number"
    t.integer "status", default: 0, null: false
    t.bigint "approved_by_id"
    t.bigint "project_id", null: false
    t.bigint "payment_method_id", null: false
    t.bigint "account_id", null: false
    t.bigint "requested_for_id", null: false
    t.integer "shipping_charges_paid_to"
    t.string "vendor", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "seq", default: 0
    t.float "surcharge", default: 0.0
    t.string "work_breakdown_structure"
    t.string "identifier"
    t.bigint "received_by_id"
    t.boolean "use_requested_for", default: false
    t.datetime "submitted_at"
    t.datetime "on_hold_until"
    t.integer "completion", default: 0, null: false
    t.index ["account_id"], name: "index_requests_on_account_id"
    t.index ["approved_by_id"], name: "index_requests_on_approved_by_id"
    t.index ["payment_method_id"], name: "index_requests_on_payment_method_id"
    t.index ["project_id"], name: "index_requests_on_project_id"
    t.index ["received_by_id"], name: "index_requests_on_received_by_id"
    t.index ["requested_for_id"], name: "index_requests_on_requested_for_id"
  end

  create_table "work_breakdown_structures", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "items", "accounts", column: "received_by_id"
  add_foreign_key "items", "accounts", column: "returned_by_id"
  add_foreign_key "items", "requests"
  add_foreign_key "projects", "clients"
  add_foreign_key "requests", "accounts"
  add_foreign_key "requests", "accounts", column: "approved_by_id"
  add_foreign_key "requests", "accounts", column: "received_by_id"
  add_foreign_key "requests", "accounts", column: "requested_for_id"
  add_foreign_key "requests", "payment_methods"
  add_foreign_key "requests", "projects"
end
