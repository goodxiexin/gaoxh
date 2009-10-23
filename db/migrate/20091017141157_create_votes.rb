class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :subscriber_id
      t.integer :poll_answer_id
      t.integer :poll_id
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
