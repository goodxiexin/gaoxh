class Photo < ActiveRecord::Base

  belongs_to :user

  belongs_to :album, :counter_cache => :photos_count

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 8.megabytes,
                 :thumbnails => { :large => '320x320>',
                                  :medium => '160x160>',
                                  :small => '80x80>'}

  validates_as_attachment

  acts_as_commentable :order => 'created_at ASC'

  acts_as_diggable

  acts_as_friend_taggable :class_name => 'PhotoTag'

	acts_as_global_resources :conditions => {:parent_id => nil}

	has_many :feed_items, :as => 'originator', :dependent => :destroy

  def is_cover?
    album.cover_id == id
  end


end
