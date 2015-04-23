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

ActiveRecord::Schema.define(version: 20150418093925) do

  create_table "emergencies", force: :cascade do |t|
    t.string   "code"
    t.integer  "fire_severity"
    t.integer  "police_severity"
    t.integer  "medical_severity"
    t.boolean  "full_response",    default: false
    t.datetime "resolved_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "emergencies", ["code"], name: "index_emergencies_on_code"
  add_index "emergencies", ["full_response"], name: "index_emergencies_on_full_response"
  add_index "emergencies", ["resolved_at"], name: "index_emergencies_on_resolved_at"

  create_table "responders", force: :cascade do |t|
    t.integer  "emergency_id"
    t.string   "type",                         null: false
    t.string   "name",                         null: false
    t.integer  "capacity",                     null: false
    t.boolean  "on_duty",      default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "responders", ["emergency_id"], name: "index_responders_on_emergency_id"
  add_index "responders", ["name"], name: "index_responders_on_name"
  add_index "responders", ["on_duty"], name: "index_responders_on_on_duty"
  add_index "responders", ["type"], name: "index_responders_on_type"

end
