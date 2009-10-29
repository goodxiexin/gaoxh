class PersonalAlbum < Album

  belongs_to :cover, :class_name => 'PersonalPhoto'

  belongs_to :user, :foreign_key => 'owner_id', :counter_cache => :albums_count

  has_many :photos, :class_name => 'PersonalPhoto', :foreign_key => 'album_id', :order => 'created_at DESC', :dependent => :destroy

	acts_as_global_resources 

end

