class EventAlbum < Album

  belongs_to :cover, :class_name => 'EventPhoto'

  belongs_to :event, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'EventPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

	before_create :set_event_info

protected

	def set_event_info
		self.title = "#{event.title}活动的相册"
		self.privilege = 1
		self.game_id = event.game_id
		self.poster_id = event.poster_id 
	end

end
