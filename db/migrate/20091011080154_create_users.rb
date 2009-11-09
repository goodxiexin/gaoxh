class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string	:login
      t.string	:email
      t.string	:gender
      t.string	:crypted_password,	:limit => 40
      t.string	:salt,			:limit => 40
      t.string	:remember_token
      t.datetime	:remember_token_expires_at
      t.string	:activation_code
      t.datetime	:activated_at
      t.string	:password_reset_code
      t.boolean	:enabled,	:default => false
			t.integer :avatar_id

      # counters
      t.integer :albums_count, :default => 0
      t.integer :friends_count, :default => 0
      t.integer :blogs_count, :default => 0
      t.integer :drafts_count, :default => 0
      t.integer :videos_count, :default => 0
      t.integer :statuses_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :requests_count, :default => 0
      t.integer :invitations_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
