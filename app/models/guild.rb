class Guild < ActiveRecord::Base
  
  belongs_to :game

  has_one :forum

  has_many :memberships

  has_many :invitations, :class_name => 'Membership', :conditions => {:status => 0}

  has_many :requests, :class_name => 'Membership', :conditions => {:status => [1,2]}

  has_many :invitees, :through => :invitations, :source => 'user'
	
  has_many :requestors, :through => :requests, :source => 'user'

	has_many :all_members, :through => :memberships, :source => 'user', :conditions => "memberships.status = 3 or memberships.status = 4 or memberships.status = 5"

  has_many :members, :through => :memberships, :source => 'user', :conditions => "memberships.status = 5"

  has_many :veterans, :through => :memberships, :source => 'user', :conditions => "memberships.status = 4"

  has_one :president, :through => :memberships, :source => 'user', :conditions => "memberships.status = 3"

	has_many :veterans_and_members, :through => :memberships, :source => 'user', :conditions => "memberships.status = 4 or memberships.status = 5"

  has_many :president_and_veterans, :through => :memberships, :source => 'user', :conditions => "memberships.status = 3 or memberships.status = 4"

  has_one :album, :class_name => 'GuildAlbum', :foreign_key => 'owner_id'

  has_many :guild_friendships

  has_many :friends, :through => :guild_friendships, :source => 'friend'

	has_many :feed_items, :as => 'originator', :dependent => :destroy

	acts_as_commentable :order => 'created_at DESC'

	acts_as_global_resources :hot_order => "all_count DESC"

  validate do |guild|
    guild.errors.add_to_base('名字不能为空') if guild.name.blank?
    guild.errors.add_to_base('名字最长100个字符') if guild.name.length > 100
    guild.errors.add_to_base('描述不能为空') if guild.description.blank?
    guild.errors.add_to_base('描述最长10000个字符') if guild.description.length > 10000
    guild.errors.add_to_base('游戏类别不能为空') if guild.game_id.blank?
  end

  def events
    self.president_and_veterans(:include => :events).map do |member|
      member.upcoming_events
    end.flatten.sort {|a,b| a.created_at <=> b.created_at}
  end

	# virtual attribute
	def president_id
		@president_id
	end

	def president_id=(id)
		@president_id = id
	end

end
