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

ActiveRecord::Schema[7.1].define(version: 2024_04_12_104110) do
  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "expense_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_comments_on_expense_id"
  end

  create_table "currents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "department"
    t.string "emp_status"
    t.boolean "admin_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_reports", force: :cascade do |t|
    t.string "title"
    t.integer "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "report_status"
    t.index ["employee_id"], name: "index_expense_reports_on_employee_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.date "date"
    t.string "description"
    t.decimal "amount"
    t.integer "invoice_no"
    t.string "approval_status"
    t.integer "expense_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_report_id"], name: "index_expenses_on_expense_report_id"
  end

  create_table "replies", force: :cascade do |t|
    t.text "content"
    t.integer "comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_replies_on_comment_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "expenses"
  add_foreign_key "expense_reports", "employees"
  add_foreign_key "expenses", "expense_reports"
  add_foreign_key "replies", "comments"
end
