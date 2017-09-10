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

ActiveRecord::Schema.define(version: 20170908062818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "horses", force: :cascade do |t|
    t.string "selectionId"
    t.string "name"
    t.integer "order"
    t.string "marketId"
    t.string "meetingId"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "days_since_last_run"
    t.string "form"
    t.string "jockey"
    t.string "trainer"
    t.string "stall_draw"
    t.string "sex"
    t.string "william_hill_odds"
    t.string "bet365_odds"
    t.string "paddy_power_odds"
    t.string "sky_bet_odds"
    t.string "ladbrokes_odds"
    t.string "bet_victor_odds"
    t.string "unibet_odds"
    t.string "sporting_bet_odds"
    t.string "betfair_odds"
    t.string "coral_odds"
    t.string "image"
    t.string "crownbet_odds"
    t.string "palmerbet_odds"
    t.string "luxbet_odds"
    t.string "sportsbet_odds"
    t.string "best_odds_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "meetingId"
    t.string "name"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oddschecker_url"
  end

  create_table "races", force: :cascade do |t|
    t.string "marketId"
    t.string "meetingId"
    t.string "time"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "best_odds_id"
    t.string "best_odds_name"
  end

  create_table "tips", force: :cascade do |t|
    t.integer "user_id"
    t.string "selectionId"
    t.string "name"
    t.integer "order"
    t.string "marketId"
    t.string "meetingId"
    t.string "meeting_name"
    t.string "race_time"
    t.string "average_odds"
    t.string "deductions"
    t.string "bsp"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "average_odds_15"
    t.string "average_odds_30"
    t.boolean "sent"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.text "about"
    t.string "password_digest"
  end

end
