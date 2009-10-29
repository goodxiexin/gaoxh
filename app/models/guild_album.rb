class GuildAlbum < Album

  belongs_to :cover, :class_name => 'GuildPhoto'

  belongs_to :guild, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'GuildPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

	before_create :set_guild_info

protected

	def set_guild_info
		self.title = "工会#{guild.name}的相册"
		self.privilege = 1
		self.game_id = guild.game_id
		self.poster_id = guild.president.id
	end

end

