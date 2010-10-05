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

ActiveRecord::Schema.define(:version => 20101004162157) do

  create_table "banners", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.boolean  "displaying",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "parent_post_id"
    t.string   "body"
    t.string   "remote_ip"
    t.string   "tags"
    t.boolean  "is_public",        :default => false
    t.boolean  "is_deleted",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.boolean  "is_block",   :default => false
    t.boolean  "is_follow",  :default => false
    t.boolean  "is_friend",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                   :default => "",           :null => false
    t.string   "encrypted_password",       :limit => 128, :default => "",           :null => false
    t.string   "password_salt",                           :default => "",           :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                         :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                   :default => false
    t.string   "username"
    t.string   "full_name"
    t.integer  "gender",                                  :default => 0
    t.integer  "gender_policy",                           :default => 0
    t.date     "birth",                                   :default => '2010-10-04'
    t.integer  "birth_policy",                            :default => 0
    t.string   "local",                                   :default => "Brasilia"
    t.string   "locale",                                  :default => "pt-BR"
    t.string   "time_zone",                               :default => "Brasilia"
    t.string   "website"
    t.text     "description"
    t.integer  "photo_id"
    t.string   "flavour",                                 :default => "orange"
    t.integer  "background_repeat_policy",                :default => 0
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
