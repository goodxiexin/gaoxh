class CreatePrivacySettings < ActiveRecord::Migration
  def self.up
    create_table :privacy_settings do |t|
      t.integer :user_id

      # 1: all 2: friends and same game 3: friends
      # configure who can see your personal page and what is viewable
      t.integer :personal, :default => 2 
      t.integer :basic_info, :default => 2
      t.integer :character_info, :default => 2
      t.integer :wall, :default => 2
      t.integer :qq, :default => 3
      t.integer :phone, :default => 3
      t.integer :website, :default => 3
      t.integer :email, :default => 3

      # configure who can send me poke or friend request
      t.integer :poke, :default => 1
      t.integer :friend, :default => 1 # 1 all, 2 same game

      # search configuration
      t.boolean :search, :default => true
    end
  end

  def self.down
    drop_table :privacy_settings
  end
end
