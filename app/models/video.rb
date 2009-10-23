class Video < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User', :counter_cache => true

  belongs_to :game

  has_many :comments, :as => 'commentable', :dependent => :destroy

  has_many :tags, :as => 'taggable', :class_name => 'FriendTag', :dependent => :destroy

  has_many :digs, :as => 'diggable', :dependent => :destroy

  before_create :generate_link

  acts_as_list :order => 'created_at DESC', :scope => 'poster_id'
  
  validate do |video|
    video.errors.add_to_base('标题不能为空') if video.title.blank?
    video.errors.add_to_base('url不能为空') if video.url.blank?
    video.errors.add_to_base('游戏类别不能为空') if video.game_id.blank?
    video.errors.add_to_base('标题太长，最长100个字符') if video.title.length >= 100
  end

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


  class VideoURLNotValid < StandardError; end

  def generate_link
    if (url =~ /youku\.com/)
      startPos = (url =~ /\/id_/)
      videoId = url[(startPos + 4)..-6]
      videoUrl = "http://player.youku.com/player.php/sid/"+ videoId +"/v.swf"
      self.link = "<embed src=\""+ videoUrl + "\" quality=\"high\" width=\"480\" height=\"400\" align=\"middle\" allowScriptAccess=\"sameDomain\" type=\"application/x-shockwave-flash\"></embed>"
    elsif (url =~ /tudou\.com/)
      startPos = (url =~ /view\//)
      videoId = url[(startPos + 5)..-2]
      videoUrl = "http://www.tudou.com/v/"+videoId
      self.link = "<object width=\"420\" height=\"363\"><param name=\"movie\" value=\""+ videoUrl +"\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><param name=\"wmode\" value=\"opaque\"></param><embed src=\""+ videoUrl+"\"type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" allowfullscreen=\"true\" wmode=\"opaque\" width=\"420\" height=\"363\"></embed></object>"
    else
      raise VideoURLNotValid    
    end
  end
 
  def tags=(ids)
    poster.friends.find(ids).each { |f| tags.build(:poster_id => poster_id, :friend_id => f.id) }
  rescue
    raise FriendTag::TagNoneFriendError
  end

end
