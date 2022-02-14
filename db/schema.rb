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

ActiveRecord::Schema.define(version: 2022_02_14_232120) do

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
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "description"
    t.string "vendor_reference"
    t.integer "quantity"
    t.float "price"
    t.bigint "request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id"], name: "index_items_on_request_id"
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
  end

  create_table "requests", force: :cascade do |t|
    t.text "notes"
    t.text "reason_for_rejection"
    t.float "shipping_cost"
    t.float "sales_tax"
    t.float "import_tax"
    t.datetime "date_received"
    t.datetime "date_approved"
    t.datetime "date_ordered"
    t.string "order_number"
    t.integer "status"
    t.bigint "approved_by_id"
    t.bigint "work_breakdown_structure_id", null: false
    t.bigint "project_id", null: false
    t.bigint "payment_method_id", null: false
    t.bigint "account_id", null: false
    t.bigint "requested_by_id", null: false
    t.integer "shipping_charges_paid_to"
    t.string "vendor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "seq", default: 0
    t.index ["account_id"], name: "index_requests_on_account_id"
    t.index ["approved_by_id"], name: "index_requests_on_approved_by_id"
    t.index ["payment_method_id"], name: "index_requests_on_payment_method_id"
    t.index ["project_id"], name: "index_requests_on_project_id"
    t.index ["requested_by_id"], name: "index_requests_on_requested_by_id"
    t.index ["work_breakdown_structure_id"], name: "index_requests_on_work_breakdown_structure_id"
  end

  create_table "work_breakdown_structures", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "items", "requests"
  add_foreign_key "requests", "accounts"
  add_foreign_key "requests", "accounts", column: "approved_by_id"
  add_foreign_key "requests", "accounts", column: "requested_by_id"
  add_foreign_key "requests", "payment_methods"
  add_foreign_key "requests", "projects"
  add_foreign_key "requests", "work_breakdown_structures"
end
