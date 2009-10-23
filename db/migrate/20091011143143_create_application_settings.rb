class CreateApplicationSettings < ActiveRecord::Migration
  def self.up
    create_table :application_settings do |t|
      t.integer :user_id
    end
  end

  def self.down
    drop_table :application_settings
  end
end
