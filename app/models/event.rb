class Event < ActiveRecord::Base

  has_one :album, :class_name => 'EventAlbum', :foreign_key => 'owner_id'

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  belongs_to :game_server

  belongs_to :game_area

  has_many :comments, :as => 'commentable', :order => 'created_at DESC', :dependent => :destroy

  has_many :participations, :dependent => :destroy

  has_many :invitations, :class_name => 'Participation', :conditions => {:status => 0}, :dependent => :destroy
  
  has_many :requests, :class_name => 'Participation', :conditions => ["status = 1 OR status = 2"], :dependent => :destroy

  has_many :participants, :through => :participations, :conditions => "status = 3 or status = 4 or status = 5"

  has_many :invitees, :through => :invitations, :source => 'participant'

  has_many :requestors, :through => :requests, :source => 'participant'

  has_many :confirmed_participants, :through => :participations, :source => 'participant', :conditions => "participations.status = 3"

  has_many :maybe_participants, :through => :participations, :source => 'participant', :conditions => "participations.status = 4"

  has_many :declined_participants, :through => :participations, :source => 'participant', :conditions => "participations.status = 5"

  validate do |event|
    event.errors.add_to_base("标题不能为空") if event.title.blank?
    event.errors.add_to_base("标题太长，最长100个字符") if event.title and event.title.length > 100
    event.errors.add_to_base("描述不能为空") if event.description.blank?
    event.errors.add_to_base("描述最长10000个字符") if event.description and event.description.length > 10000
    event.errors.add_to_base("游戏类别不能为空") if event.game_id.blank?
    event.errors.add_to_base("游戏服务器不能为空") if event.game_server_id.blank?
    event.errors.add_to_base("游戏服务区不能为空") if !event.game.no_areas and event.game_area_id.blank?
    event.errors.add_to_base("开始时间不能为空") if event.start_time.blank?
    event.errors.add_to_base("开始时间不能比现在早") if event.start_time and event.start_time <= Time.now
    event.errors.add_to_base("结束时间不能为空") if event.end_time.blank?
    event.errors.add_to_base("结束时间不能比开始时间早") if event.end_time and event.end_time <= event.start_time 
  end

  # virtual attribute: past?
  def past
    start_time < Time.now
  end

  named_scope :hot, lambda { |game_id|
    if game_id.blank?
      cond = {:conditions => ["start_time > ?", Time.now.to_s(:db)]}
    else
      cond = {:conditions => ["start_time > ? AND game_id = ", Time.now.to_s(:db), game_id]}    
    end
    {:order => "confirmed_count DESC"}.merge cond
  }

  named_scope :recent, lambda { |game_id|
    if game_id.blank?
      cond = {:conditions => ["start_time > ?", Time.now.to_s(:db)]}
    else
      cond = {:conditions => ["start_time > ? AND game_id = ", Time.now.to_s(:db), game_id]}
    end
    {:order => "created_at DESC"}.merge cond
  }
  
end
