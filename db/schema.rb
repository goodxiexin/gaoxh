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

ActiveRecord::Schema.define(:version => 20091028102747) do

  create_table "albums", :force => true do |t|
    t.string   "type"
    t.integer  "poster_id"
    t.integer  "owner_id"
    t.integer  "game_id"
    t.integer  "photos_count",   :default => 0
    t.integer  "privilege",      :default => 1
    t.integer  "cover_id"
    t.string   "title"
    t.text     "description"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "application_settings", :force => true do |t|
    t.integer "user_id"
    t.boolean "emit_blog_feed",  :default => true
    t.boolean "recv_blog_feed",  :default => true
    t.boolean "emit_video_feed", :default => true
    t.boolean "recv_video_feed", :default => true
    t.boolean "emit_photo_feed", :default => true
    t.boolean "recv_photo_feed", :default => true
    t.boolean "emit_poll_feed",  :default => true
    t.boolean "recv_poll_feed",  :default => true
    t.boolean "emit_event_feed", :default => true
    t.boolean "recv_event_feed", :default => true
    t.boolean "emit_guild_feed", :default => true
    t.boolean "recv_guild_feed", :default => true
  end

  create_table "blogs", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "game_id"
    t.string   "title",          :limit => 64
    t.text     "content",        :limit => 16777215
    t.integer  "digs_count",                         :default => 0
    t.integer  "comments_count",                     :default => 0
    t.integer  "tags_count",                         :default => 0
    t.boolean  "draft",                              :default => true
    t.integer  "privilege",                          :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "recipient_id"
    t.boolean  "whisper",          :default => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "digs", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "diggable_id"
    t.string   "diggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.integer  "poster_id"
    t.integer  "game_id"
    t.integer  "game_server_id"
    t.integer  "game_area_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "description"
    t.integer  "privilege",        :default => 1
    t.integer  "comments_count",   :default => 0
    t.integer  "invitees_count",   :default => 0
    t.integer  "requestors_count", :default => 0
    t.integer  "confirmed_count",  :default => 0
    t.integer  "maybe_count",      :default => 0
    t.integer  "declined_count",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_deliveries", :force => true do |t|
    t.integer  "recipient_id"
    t.integer  "feed_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_items", :force => true do |t|
    t.text     "data"
    t.string   "originator_type"
    t.integer  "originator_id"
    t.datetime "expired_at"
    t.datetime "created_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "topics_count",  :default => 0
    t.integer  "posts_count",   :default => 0
    t.integer  "guild_id"
    t.integer  "last_topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friend_tags", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "friend_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "friend_id"
    t.integer  "user_id"
    t.integer  "status"
    t.string   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_areas", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.integer  "servers_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_characters", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "server_id"
    t.integer  "area_id"
    t.integer  "profession_id"
    t.integer  "race_id"
    t.string   "name"
    t.integer  "level"
    t.boolean  "playing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_professions", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_races", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_servers", :force => true do |t|
    t.string   "name"
    t.string   "ip"
    t.integer  "game_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.datetime "sale_date"
    t.text     "description"
    t.boolean  "no_areas",          :default => false
    t.integer  "areas_count",       :default => 0
    t.integer  "servers_count",     :default => 0
    t.integer  "professions_count", :default => 0
    t.integer  "races_count",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guild_friendships", :force => true do |t|
    t.integer  "guild_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guilds", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.string   "description"
    t.integer  "all_count",        :default => 0
    t.integer  "members_count",    :default => 0
    t.integer  "veterans_count",   :default => 0
    t.integer  "presidents_count", :default => 0
    t.integer  "invitees_count",   :default => 0
    t.integer  "requestors_count", :default => 0
    t.integer  "comments_count",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_settings", :force => true do |t|
    t.integer "user_id"
    t.boolean "mail_me",                       :default => true
    t.boolean "request_to_be_friend",          :default => true
    t.boolean "confirm_friend",                :default => true
    t.boolean "birthday",                      :default => false
    t.boolean "comment_my_status",             :default => true
    t.boolean "comment_same_status_after_me",  :default => true
    t.boolean "comment_my_profile",            :default => true
    t.boolean "comment_same_profile_after_me", :default => true
    t.boolean "poke_me",                       :default => true
    t.boolean "tag_me_in_photo",               :default => true
    t.boolean "tag_my_photo",                  :default => true
    t.boolean "comment_my_album",              :default => true
    t.boolean "comment_same_album_after_me",   :default => true
    t.boolean "comment_my_photo",              :default => true
    t.boolean "comment_photo_contains_me",     :default => true
    t.boolean "comment_same_photo_after_me",   :default => true
    t.boolean "tag_me_in_blog",                :default => true
    t.boolean "comment_my_blog",               :default => true
    t.boolean "comment_same_blog_after_me",    :default => true
    t.boolean "comment_blog_contains_me",      :default => true
    t.boolean "tag_me_in_video",               :default => true
    t.boolean "comment_my_video",              :default => true
    t.boolean "comment_same_video_after_me",   :default => true
    t.boolean "comment_video_contains_me",     :default => true
    t.boolean "invite_me_to_event",            :default => true
    t.boolean "change_time_of_event",          :default => true
    t.boolean "change_place_of_event",         :default => true
    t.boolean "cancel_event",                  :default => true
    t.boolean "request_to_attend_my_event",    :default => true
    t.boolean "comment_my_event",              :default => true
    t.boolean "comment_same_event_after_me",   :default => true
    t.boolean "change_name_of_guild",          :default => true
    t.boolean "invite_me_to_guild",            :default => true
    t.boolean "promotion_to_president",        :default => true
    t.boolean "promotion_to_veteran",          :default => true
    t.boolean "request_to_attend_my_guild",    :default => true
    t.boolean "reply_my_post",                 :default => true
    t.boolean "comment_same_guild_after_me",   :default => true
    t.boolean "invite_me_to_poll",             :default => true
    t.boolean "poll_expire",                   :default => true
    t.boolean "comment_my_poll",               :default => true
    t.boolean "comment_same_poll_after_me",    :default => true
    t.boolean "poll_summary_change",           :default => true
  end

  create_table "mails", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "delete_by_sender",    :default => false
    t.boolean  "delete_by_recipient", :default => false
    t.boolean  "read_by_recipient",   :default => false
    t.string   "title"
    t.text     "content"
    t.integer  "parent_id",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "guild_id"
    t.integer  "president_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moderator_forums", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "moderator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.text     "data"
    t.integer  "user_id"
    t.string   "notifier_type"
    t.integer  "notifier_id"
    t.boolean  "read",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participations", :force => true do |t|
    t.integer  "participant_id"
    t.integer  "event_id"
    t.integer  "status",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_tags", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "tagged_user_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "type"
    t.integer  "digs_count",     :default => 0
    t.integer  "tags_count",     :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "album_id"
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "position"
    t.text     "notation"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poke_deliveries", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "poke_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pokes", :force => true do |t|
    t.string "name"
    t.string "path"
  end

  create_table "poll_answers", :force => true do |t|
    t.string   "description"
    t.integer  "poll_id"
    t.integer  "votes_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poll_invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "polls", :force => true do |t|
    t.string   "name"
    t.integer  "poster_id"
    t.integer  "game_id"
    t.text     "description"
    t.text     "explanation"
    t.integer  "max_multiple"
    t.date     "end_date"
    t.text     "summary"
    t.integer  "privilege",      :default => 2
    t.integer  "comments_count", :default => 0
    t.integer  "votes_count",    :default => 0
    t.integer  "voters_count",   :default => 0
    t.integer  "answers_count",  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "forum_id"
    t.integer  "poster_id"
    t.text     "content"
    t.integer  "floor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privacy_settings", :force => true do |t|
    t.integer "user_id"
    t.integer "personal",       :default => 2
    t.integer "basic_info",     :default => 2
    t.integer "character_info", :default => 2
    t.integer "wall",           :default => 2
    t.integer "qq",             :default => 3
    t.integer "phone",          :default => 3
    t.integer "website",        :default => 3
    t.integer "email",          :default => 3
    t.integer "poke",           :default => 1
    t.integer "friend",         :default => 1
    t.boolean "search",         :default => true
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "gender"
    t.integer  "country_id"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "qq"
    t.integer  "phone"
    t.string   "website"
    t.datetime "birthday"
    t.text     "about_me"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sharings", :force => true do |t|
    t.integer  "shareable_id"
    t.string   "shareable_type"
    t.integer  "poster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "poster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "taggings_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "poster_id"
    t.string   "subject"
    t.text     "content"
    t.integer  "posts_count",  :default => 0
    t.boolean  "top",          :default => false
    t.integer  "last_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "gender"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "password_reset_code"
    t.boolean  "enabled",                                 :default => false
    t.integer  "avatar_id"
    t.integer  "albums_count",                            :default => 0
    t.integer  "friends_count",                           :default => 0
    t.integer  "blogs_count",                             :default => 0
    t.integer  "drafts_count",                            :default => 0
    t.integer  "videos_count",                            :default => 0
    t.integer  "statuses_count",                          :default => 0
    t.integer  "comments_count",                          :default => 0
    t.integer  "event_requests_count",                    :default => 0
    t.integer  "event_invitations_count",                 :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.integer  "poster_id"
    t.integer  "game_id"
    t.string   "title"
    t.string   "url"
    t.text     "link"
    t.integer  "digs_count",     :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "tags_count",     :default => 0
    t.integer  "privilege",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visitor_records", :force => true do |t|
    t.integer  "visitor_id"
    t.integer  "profile_id"
    t.datetime "created_at"
  end

  create_table "votes", :force => true do |t|
    t.text     "answer_ids"
    t.integer  "voter_id"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
