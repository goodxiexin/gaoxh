class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
			t.integer :messages_count, :default => 0
			t.integer :sender_id
			t.integer :recipient_id
      t.timestamps
    end
  end

  def self.down
    drop_table :conversations
  end
end
