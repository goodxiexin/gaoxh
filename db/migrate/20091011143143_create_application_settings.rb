class CreateApplicationSettings < ActiveRecord::Migration
  def self.up
    create_table :application_settings do |t|
      t.integer :user_id
			t.boolean	:emit_blog_feed, :default => true
			t.boolean	:recv_blog_feed, :default => true
			t.boolean :emit_video_feed, :default => true
      t.boolean :recv_video_feed, :default => true
			t.boolean :emit_photo_feed, :default => true
      t.boolean :recv_photo_feed, :default => true
			t.boolean :emit_poll_feed, :default => true
      t.boolean :recv_poll_feed, :default => true
			t.boolean :emit_event_feed, :default => true
      t.boolean :recv_event_feed, :default => true
			t.boolean :emit_guild_feed, :default => true
      t.boolean :recv_guild_feed, :default => true
    end
  end

  def self.down
    drop_table :application_settings
  end
end
