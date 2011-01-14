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

ActiveRecord::Schema.define(:version => 20110114072156) do

  create_table "banners", :force => true do |t|
    t.string    "name"
    t.string    "link"
    t.boolean   "displaying",       :default => true
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "img_file_name"
    t.string    "img_content_type"
    t.integer   "img_file_size"
    t.timestamp "img_updated_at"
  end

  create_table "delayed_mail_followeds", :force => true do |t|
    t.integer   "user_id"
    t.integer   "follower_user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "hostnesses", :force => true do |t|
    t.integer   "user_id"
    t.string    "country"
    t.string    "state"
    t.string    "city"
    t.string    "hostness_type", :default => "normal"
    t.boolean   "is_active",     :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "page_translations", :force => true do |t|
    t.integer   "page_id"
    t.string    "locale"
    t.text      "body"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "page_translations", ["page_id"], :name => "index_page_translations_on_page_id"

  create_table "pages", :force => true do |t|
    t.string    "key"
    t.text      "body"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "img_file_name"
    t.string    "img_content_type"
    t.integer   "img_file_size"
    t.timestamp "img_updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "body"
    t.string   "remote_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "links"
    t.string   "file_types"
    t.string   "usernames"
  end

  create_table "relationships", :force => true do |t|
    t.integer   "user1_id"
    t.integer   "user2_id"
    t.boolean   "is_followed",      :default => false
    t.boolean   "is_follower",      :default => false
    t.boolean   "is_friend",        :default => false
    t.boolean   "is_blocked",       :default => false
    t.boolean   "is_blocker",       :default => false
    t.string    "ignored_subjects",                    :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string    "session_id", :null => false
    t.text      "data"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subjects", :force => true do |t|
    t.integer   "user_id"
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "posts_count", :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                        :default => "",           :null => false
    t.string   "encrypted_password",            :limit => 128, :default => "",           :null => false
    t.string   "password_salt",                                :default => "",           :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                              :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                        :default => false
    t.string   "username"
    t.string   "full_name"
    t.integer  "gender",                                       :default => 0
    t.integer  "gender_policy",                                :default => 0
    t.date     "birth",                                        :default => '2010-10-30'
    t.integer  "birth_policy",                                 :default => 0
    t.string   "local",                                        :default => ""
    t.string   "locale",                                       :default => "pt-BR"
    t.string   "time_zone",                                    :default => "Brasilia"
    t.string   "website"
    t.text     "description"
    t.integer  "photo_id"
    t.string   "flavour",                                      :default => "orange"
    t.integer  "background_repeat_policy",                     :default => 0
    t.integer  "background_attachment_policy",                 :default => 0
    t.string   "background_color"
    t.string   "background_position"
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.integer  "posts_count",                                  :default => 0
    t.boolean  "is_host"
    t.integer  "post_id"
    t.string   "relations_hash_count"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "xlinks", :force => true do |t|
    t.integer   "user_id"
    t.string    "micro"
    t.integer   "file_width"
    t.integer   "file_height"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "file_file_name"
    t.string    "file_content_type"
    t.integer   "file_file_size"
    t.timestamp "file_updated_at"
    t.integer   "requests_count",    :default => 0
  end

end
