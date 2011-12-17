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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111217170828) do

  create_table "listens", :force => true do |t|
    t.string   "track_id",   :null => false
    t.integer  "user_id",    :null => false
    t.string   "state",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      :null => false
    t.string   "artist",     :null => false
    t.datetime "played_at"
  end

  add_index "listens", ["played_at", "user_id", "track_id"], :name => "index_listens_on_played_at_and_user_id_and_track_id"
  add_index "listens", ["played_at"], :name => "index_listens_on_played_at"
  add_index "listens", ["track_id"], :name => "index_listens_on_track_id"
  add_index "listens", ["user_id"], :name => "index_listens_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "lastfm_username",   :null => false
    t.string   "session_key",       :null => false
    t.string   "rhapsody_state",    :null => false
    t.string   "lastfm_state",      :null => false
    t.string   "rhapsody_username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["lastfm_username"], :name => "index_users_on_lastfm_username"
  add_index "users", ["rhapsody_username"], :name => "index_users_on_rhapsody_username"

end
