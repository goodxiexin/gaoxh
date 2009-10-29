class CreateFeedDeliveries < ActiveRecord::Migration
  def self.up
    create_table :feed_deliveries do |t|
			t.integer :recipient_id
			t.integer :feed_item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_deliveries
  end
end
