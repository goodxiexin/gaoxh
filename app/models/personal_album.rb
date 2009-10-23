class PersonalAlbum < Album

  belongs_to :cover, :class_name => 'PersonalPhoto'

  belongs_to :user, :foreign_key => 'owner_id', :counter_cache => :albums_count

  has_many :photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

  named_scope :viewable, lambda { |relationship, game_id|
    case relationship
    when 'owner'
      cond = game_id.blank? ? {} : {:conditions => ["game_id = ?", game_id]}
    when 'friend'
      cond = game_id.blank? ? {:conditions => ["privilege = 1 or privilege = 2 or privilege = 3"]} : {:conditions => ["(privilege = 1 or privilege = 2 or privilege = 3) and game_id = #{game_id}"]}
    when 'same_game'
      cond = game_id.blank? ? {:conditions => ["privilege = 1 or privilege = 2"]} : {:conditions => ["(privilege = 1 or privilege = 2) and game_id = #{game_id}"]}
    when 'stranger'
      cond = game_id.blank? ? {:conditions => ["privilege = 1"]} : {:conditions => ["privilege = 1 and game_id = #{game_id}"]}
    end
    {:order => 'created_at DESC'}.merge cond
  }

  named_scope :hot, lambda { |game_id|
    game_cond = game_id.blank? ? {} : {:conditions => ["game_id = ?", game_id]}
    {:order => "digs_count DESC"}.merge game_cond
  }

  named_scope :recent, lambda { |game_id|
    game_cond = game_id.blank? ? {} : {:conditions => ["game_id = ?", game_id]}
    {:order => "created_at DESC"}.merge game_cond
  }

  def recent_photos(limit)
    photos.find(:all, :limit => limit)
  end

end

