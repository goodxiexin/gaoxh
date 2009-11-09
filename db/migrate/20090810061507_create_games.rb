class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games, :force => true do |t|
      t.string :name
      t.string :official_web
      t.string :company
      t.string :agent
      t.datetime :sale_date
      t.text :description
      t.boolean :no_areas, :default => false
      t.boolean :no_races, :default => false
      t.boolean :no_professions, :default => false
      t.integer :areas_count, :default => 0
      t.integer :servers_count, :default => 0
      t.integer :professions_count, :default => 0
      t.integer :races_count, :default => 0
      t.boolean :stop_running, :default => false
      t.timestamps
    end
  end


  def self.down
    drop_table :games
  end
end
