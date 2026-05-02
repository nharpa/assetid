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

ActiveRecord::Schema[8.1].define(version: 2026_05_02_000008) do
  create_table "asset_characteristic_values", force: :cascade do |t|
    t.integer "asset_class_characteristic_id", null: false
    t.integer "asset_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.index ["asset_class_characteristic_id"], name: "idx_on_asset_class_characteristic_id_f5aebe7434"
    t.index ["asset_id", "asset_class_characteristic_id"], name: "index_acv_on_asset_and_acc", unique: true
    t.index ["asset_id"], name: "index_asset_characteristic_values_on_asset_id"
  end

  create_table "asset_class_characteristics", force: :cascade do |t|
    t.integer "asset_class_id", null: false
    t.integer "characteristic_id", null: false
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.boolean "required", default: false, null: false
    t.datetime "updated_at", null: false
    t.index ["asset_class_id", "characteristic_id"], name: "index_acc_on_asset_class_and_characteristic", unique: true
    t.index ["asset_class_id"], name: "index_asset_class_characteristics_on_asset_class_id"
    t.index ["characteristic_id"], name: "index_asset_class_characteristics_on_characteristic_id"
  end

  create_table "asset_classes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_asset_classes_on_name", unique: true
  end

  create_table "assets", force: :cascade do |t|
    t.integer "asset_class_id", null: false
    t.string "asset_tag", null: false
    t.datetime "created_at", null: false
    t.date "installation_date"
    t.datetime "last_inspected_at"
    t.integer "location_id", null: false
    t.string "make"
    t.string "model"
    t.string "name", null: false
    t.integer "parent_asset_id"
    t.decimal "purchase_cost", precision: 12, scale: 2
    t.date "purchase_date"
    t.string "serial_number"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_class_id"], name: "index_assets_on_asset_class_id"
    t.index ["asset_tag"], name: "index_assets_on_asset_tag", unique: true
    t.index ["location_id"], name: "index_assets_on_location_id"
    t.index ["parent_asset_id"], name: "index_assets_on_parent_asset_id"
  end

  create_table "characteristic_allowed_values", force: :cascade do |t|
    t.integer "characteristic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.index ["characteristic_id"], name: "index_characteristic_allowed_values_on_characteristic_id"
  end

  create_table "characteristics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "data_type", null: false
    t.text "description"
    t.string "name", null: false
    t.string "unit"
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "address_line_1"
    t.string "address_line_2"
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "plant_name", null: false
    t.string "state"
    t.string "suburb", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "staff", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "asset_characteristic_values", "asset_class_characteristics"
  add_foreign_key "asset_characteristic_values", "assets"
  add_foreign_key "asset_class_characteristics", "asset_classes"
  add_foreign_key "asset_class_characteristics", "characteristics"
  add_foreign_key "assets", "asset_classes"
  add_foreign_key "assets", "locations"
  add_foreign_key "characteristic_allowed_values", "characteristics"
end
