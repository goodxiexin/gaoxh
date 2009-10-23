class AvatarAlbum < Album

  belongs_to :user, :foreign_key => 'owner_id', :counter_cache => :albums_count

  has_many :photos, :class_name => 'Avatar', :dependent => :destroy, :foreign_key => 'album_id', :order => 'created_at DESC'

end
