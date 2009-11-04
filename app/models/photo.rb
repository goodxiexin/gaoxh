class Photo < ActiveRecord::Base

  belongs_to :user

	belongs_to :album, :counter_cache => :photos_count

  acts_as_commentable :order => 'created_at ASC'

  acts_as_diggable

	has_many :tags, :class_name => 'PhotoTag', :dependent => :destroy

	has_many :relative_users, :through => :tags, :source => 'tagged_user'
	
	acts_as_global_resources :conditions => {:parent_id => nil}

	has_many :feed_items, :as => 'originator', :dependent => :destroy

  def is_cover?
    album.cover_id == id
  end

end
