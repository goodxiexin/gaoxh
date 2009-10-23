class Blog < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  has_many :comments, :as => 'commentable', :dependent => :destroy, :order => 'created_at ASC'

  has_many :tags, :class_name => 'FriendTag', :as => 'taggable', :dependent => :destroy

  has_many :digs, :as => 'diggable', :dependent => :destroy

  validate do |blog|
    blog.errors.add_to_base('标题不能为空') if blog.title.blank?
    blog.errors.add_to_base('请选择游戏类别') if blog.game_id.blank?
    blog.errors.add_to_base('标题最长100个字符') if blog.title.length >= 100
    blog.errors.add_to_base('内容最长10000个字符') if blog.content.length >= 10000
  end

  acts_as_list :order => 'created_at', :scope => 'poster_id'

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
    if game_id.blank?
      game_cond = {:conditions => ["draft = 0"]}
    else
      game_cond = {:conditions => ["draft = 0 AND game_id = ?", game_id]}
    end
    {:order => "digs_count DESC"}.merge game_cond
  }

  named_scope :recent, lambda { |game_id|
    if game_id.blank?
      game_cond = {:conditions => ["draft = 0"]}
    else
      game_cond = {:conditions => ["draft = 0 AND game_id = ?", game_id]}
    end
    {:order => "created_at DESC"}.merge game_cond
  }

  def tags=(ids)
    poster.friends.find(ids).each { |f| tags.build(:poster_id => poster_id, :friend_id => f.id) }
  rescue
    raise FriendTag::TagNoneFriendError
  end


end
