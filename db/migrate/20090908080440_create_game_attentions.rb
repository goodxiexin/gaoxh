class CreateGameAttentions < ActiveRecord::Migration
  def self.up
    create_table :game_attentions do |t|
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
  end

  def self.down
    drop_table :game_attentions
  end
end
