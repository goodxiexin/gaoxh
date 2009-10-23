class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :poster_id
      t.integer :recipient_id
      t.boolean :whisper, :default => false
      t.integer :commentable_id
      t.string :commentable_type
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
