class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.integer :initiator_id
      t.integer :recipient_id
      t.integer :mails_count, :default => 0
      t.string :last_sent_mail # last mail sent by initiator
      t.string :last_recv_mail # last mail received by initiator
      t.datetime :last_sent_at
      t.datetime :last_recv_at
    end
  end

  def self.down
    drop_table :conversations
  end
end
