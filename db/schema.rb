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

ActiveRecord::Schema[7.0].define(version: 2023_03_05_201310) do
  create_table "choices", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.integer "count"
    t.integer "auth_count"
    t.bigint "word_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_choices_on_created_at"
    t.index ["updated_at"], name: "index_choices_on_updated_at"
    t.index ["word_id", "name"], name: "index_choices_on_word_id_and_name", unique: true
    t.index ["word_id"], name: "index_choices_on_word_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["updated_at"], name: "index_users_on_updated_at"
  end

  create_table "votes", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "choice_id", null: false
    t.boolean "authenticated", null: false
    t.bigint "user_id"
    t.string "session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["choice_id"], name: "index_votes_on_choice_id"
    t.index ["created_at"], name: "index_votes_on_created_at"
    t.index ["session", "choice_id"], name: "index_votes_on_session_and_choice_id", unique: true
    t.index ["updated_at"], name: "index_votes_on_updated_at"
    t.index ["user_id", "choice_id"], name: "index_votes_on_user_id_and_choice_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  create_table "words", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_words_on_created_at"
    t.index ["name"], name: "index_words_on_name", unique: true
    t.index ["slug"], name: "index_words_on_slug", unique: true
    t.index ["updated_at"], name: "index_words_on_updated_at"
  end

  add_foreign_key "choices", "words"
  add_foreign_key "votes", "choices"
  add_foreign_key "votes", "users"
end
