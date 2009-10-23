class EventAlbum < Album

  belongs_to :cover, :class_name => 'EventPhoto'

  belongs_to :event, :foreign_key => 'owner_id'

  has_many :photos, :class_name => 'EventPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

end
