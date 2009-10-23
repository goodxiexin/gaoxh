class Game < ActiveRecord::Base

  has_many :servers, :class_name => 'GameServer', :dependent => :destroy
  
  has_many :areas, :class_name => 'GameArea', :dependent => :destroy

  has_many :professions, :class_name => 'GameProfession', :dependent => :destroy

  has_many :races, :class_name => 'GameRace', :dependent => :destroy

end
