class Poll < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  has_many :answers, :class_name => 'PollAnswer', :dependent => :destroy

  has_many :votes

  has_many :subscribers, :through => :votes, :uniq => true

  has_many :comments, :as => 'commentable', :dependent => :destroy 

  validate do |poll|
    poll.errors.add_to_base("名字不能为空") if poll.name.blank?
    poll.errors.add_to_base("名字不能超过100个字符") if poll.name.length > 100
    poll.errors.add_to_base("描述不能超过5000个字符") if poll.description.length > 5000
    poll.errors.add_to_base("结束时间要比今天晚阿") if poll.end_date <= Time.now.to_date 
    poll.errors.add_to_base("游戏类别不能为空") if poll.game_id.blank?
  end

  def past
    end_date < Time.now.to_date
  end

  def votes_by user
    votes.find(:all, :conditions => {:subscriber_id => user.id})
  end

  named_scope :hot, lambda { |game_id|
    game_cond = game_id.blank? ? {} : {:conditions => ["game_id = ?", game_id]}
    {:order => "subscribers_count DESC"}.merge game_cond
  }

  named_scope :recent, lambda { |game_id|
    game_cond = game_id.blank? ? {} : {:conditions => ["game_id = ?", game_id]}
    {:order => "created_at DESC"}.merge game_cond
  }




end
