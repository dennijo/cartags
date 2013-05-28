# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100929191306) do

  create_table "comments", :force => true do |t|
    t.integer  "picture_id", :null => false
    t.integer  "user_id",    :null => false
    t.text     "comment",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "pictures", :force => true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.string   "location"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "guid"
    t.string   "title"
    t.integer  "views",                                              :default => 0
    t.decimal  "latitude",           :precision => 15, :scale => 10
    t.decimal  "longitude",          :precision => 15, :scale => 10
    t.decimal  "rating_average",     :precision => 6,  :scale => 2,  :default => 0.0
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "county"
    t.boolean  "tod",                                                :default => false
  end

  add_index "pictures", ["guid"], :name => "unique_guid", :unique => true

  create_table "profiles", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "dob"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_url"
  end

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id",                       :null => false
    t.text     "data",       :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sources", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "external_id",     :null => false
    t.integer  "source_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "unique_email"
    t.text     "fb_access_token"
    t.boolean  "superuser"
  end

end
