class Game < ActiveRecord::Base

  has_many :game_attentions, :dependent => :destroy

  has_many :servers, :class_name => 'GameServer', :dependent => :destroy
  
  has_many :areas, :class_name => 'GameArea', :dependent => :destroy

  has_many :professions, :class_name => 'GameProfession', :dependent => :destroy

  has_many :races, :class_name => 'GameRace', :dependent => :destroy

  acts_as_rateable

  acts_as_taggable

  def new_game?
    (self.sale_date.nil? or self.sale_date > Date.today)
  end  

end
