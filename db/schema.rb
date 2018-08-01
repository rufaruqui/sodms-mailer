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

ActiveRecord::Schema.define(version: 20180801130137) do

  create_table "emails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "creatorid"
    t.string   "subject"
    t.text     "body",            limit: 65535
    t.integer  "state",                         default: 0
    t.integer  "permitteddepoid"
    t.integer  "clientid"
    t.string   "from_name"
    t.string   "from_address"
    t.string   "reply_address"
    t.datetime "scheduled_on"
    t.datetime "sent_on"
    t.json     "recipients"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "attachment"
  end

  create_table "mail_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "schedule"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "schedulers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "task_name"
    t.string   "execution_time"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
