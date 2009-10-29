class CreateMailSettings < ActiveRecord::Migration
  def self.up
    create_table :mail_settings do |t|
      t.integer :user_id
      
      # general mail setting
      t.boolean :mail_me, :default => true
      t.boolean :request_to_be_friend, :default => true
      t.boolean :confirm_friend, :default => true
      t.boolean :birthday, :default => false
    
      # status
      t.boolean :comment_my_status, :default => true
      t.boolean :comment_same_status_after_me, :default => true

      # profile
			t.boolean :comment_my_profile, :default => true
			t.boolean :comment_same_profile_after_me, :default => true

      # poke
      t.boolean :poke_me, :default => true
 
      # photo
      t.boolean :tag_me_in_photo, :default => true
      t.boolean :tag_my_photo, :default => true
			t.boolean :comment_my_album, :default => true
			t.boolean :comment_same_album_after_me, :default => true
      t.boolean :comment_my_photo, :default => true
      t.boolean :comment_photo_contains_me, :default => true
      t.boolean :comment_same_photo_after_me, :default => true

      # blog
      t.boolean :tag_me_in_blog, :default => true
      t.boolean :comment_my_blog, :default => true
      t.boolean :comment_same_blog_after_me, :default => true
      t.boolean :comment_blog_contains_me, :default => true
     
      # video
      t.boolean :tag_me_in_video, :default => true
      t.boolean :comment_my_video, :default => true
      t.boolean :comment_same_video_after_me, :default => true
      t.boolean :comment_video_contains_me, :default => true

      # event
      t.boolean :invite_me_to_event, :default => true
      t.boolean :change_time_of_event, :default => true
      t.boolean :change_place_of_event, :default => true
      t.boolean :cancel_event, :default => true
      t.boolean :request_to_attend_my_event, :default => true
      t.boolean :comment_my_event, :default => true
      t.boolean :comment_same_event_after_me, :default => true

      # guild
			t.boolean	:change_name_of_guild, :default => true
      t.boolean :invite_me_to_guild, :default => true
      t.boolean :promotion_to_president, :default => true
      t.boolean :promotion_to_veteran, :default => true
      t.boolean :request_to_attend_my_guild, :default => true
      t.boolean :reply_my_post, :default => true
      t.boolean :comment_same_guild_after_me, :default => true

      # poll
      t.boolean :invite_me_to_poll, :default => true
      t.boolean :poll_expire, :default => true
      t.boolean :comment_my_poll, :default => true
      t.boolean :comment_same_poll_after_me, :default => true
      t.boolean :poll_summary_change, :default => true
    end
  end

  def self.down
    drop_table :mail_settings
  end
end
