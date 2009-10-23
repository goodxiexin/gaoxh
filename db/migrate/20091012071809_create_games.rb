class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name
      t.string :company
      t.datetime :sale_date
      t.text :description
      t.boolean :no_areas, :default => false
      t.integer :areas_count, :default => 0
      t.integer :servers_count, :default => 0
      t.integer :professions_count, :default => 0
      t.integer :races_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
