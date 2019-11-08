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

ActiveRecord::Schema.define(version: 20191108162629) do

  create_table "bikes", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.string "image"
    t.string "vehicle_num"
    t.string "security_area"
    t.integer "security_num"
    t.integer "status", default: 0
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bikes_on_user_id"
  end

  create_table "tourist_bikes", force: :cascade do |t|
    t.integer "bike_id"
    t.integer "tourist_id"
    t.date "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_prob"
    t.integer "tourist_prob"
    t.string "order_id"
    t.integer "amount"
    t.datetime "paid_date"
    t.string "authorization_id"
    t.string "capture_id"
    t.integer "place_id"
    t.time "rent_time"
    t.index ["bike_id"], name: "index_tourist_bikes_on_bike_id"
    t.index ["tourist_id"], name: "index_tourist_bikes_on_tourist_id"
  end

  create_table "tourists", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.string "phmnumber"
    t.boolean "temp_terms", default: false
    t.integer "terms", default: 0
    t.integer "tutorial", default: 0
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "authenticated"
    t.string "authenticate_url"
    t.datetime "authenticate_expire"
  end

  create_table "user_reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tourist_bike_id"
    t.integer "rate"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tourist_bike_id"], name: "index_user_reviews_on_tourist_bike_id"
    t.index ["user_id"], name: "index_user_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.boolean "temp_terms", default: false
    t.integer "terms", default: 0
    t.integer "tutorial", default: 0
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "authenticated"
    t.string "authenticate_url"
    t.datetime "authenticate_expire"
  end

end
