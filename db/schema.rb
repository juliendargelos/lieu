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

ActiveRecord::Schema.define(version: 2018_05_15_091442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "avatars", force: :cascade do |t|
    t.integer "haircut"
    t.integer "eyes"
    t.integer "face"
    t.integer "sweater"
    t.integer "mouth"
    t.integer "skin"
    t.integer "accessory"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_avatars_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.integer "number_of_chapters"
    t.text "summary"
    t.string "icon_file_name"
    t.string "icon_content_type"
    t.integer "icon_file_size"
    t.datetime "icon_updated_at"
    t.integer "color"
    t.string "author"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "instruction"
    t.integer "position"
    t.integer "brush"
    t.bigint "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "connections", force: :cascade do |t|
    t.bigint "reading_id"
    t.bigint "other_reading_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["other_reading_id"], name: "index_connections_on_other_reading_id"
    t.index ["reading_id"], name: "index_connections_on_reading_id"
  end

  create_table "draws", force: :cascade do |t|
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.bigint "chapter_id"
    t.bigint "reading_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_draws_on_chapter_id"
    t.index ["reading_id"], name: "index_draws_on_reading_id"
  end

  create_table "emojis", force: :cascade do |t|
    t.integer "kind"
    t.jsonb "position"
    t.bigint "reading_id"
    t.string "subject_type"
    t.bigint "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reading_id"], name: "index_emojis_on_reading_id"
    t.index ["subject_type", "subject_id"], name: "index_emojis_on_subject_type_and_subject_id"
  end

  create_table "readings", force: :cascade do |t|
    t.boolean "finished", default: false
    t.bigint "user_id"
    t.bigint "chapter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_readings_on_chapter_id"
    t.index ["user_id"], name: "index_readings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "pseudo", null: false
    t.string "email"
    t.string "password_digest"
    t.boolean "tutorial_done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pseudo"], name: "index_users_on_pseudo"
  end

  add_foreign_key "avatars", "users"
  add_foreign_key "chapters", "books"
  add_foreign_key "connections", "readings"
  add_foreign_key "connections", "readings", column: "other_reading_id"
  add_foreign_key "draws", "chapters"
  add_foreign_key "draws", "readings"
  add_foreign_key "emojis", "readings"
  add_foreign_key "readings", "chapters"
  add_foreign_key "readings", "users"
end
