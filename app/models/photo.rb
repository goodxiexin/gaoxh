class Photo < ActiveRecord::Base

  belongs_to :user

  has_many :comments, :as => 'commentable', :order => 'created_at ASC', :dependent => :destroy

  has_many :digs, :as => 'diggable', :dependent => :destroy

  has_many :photo_tags, :order => 'created_at DESC', :dependent => :destroy

  belongs_to :album, :counter_cache => :photos_count

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 8.megabytes,
                 :thumbnails => { :large => '320x320>',
                                  :medium => '160x160>',
                                  :small => '80x80>'}

  validates_as_attachment

  def is_cover?
    album.cover_id == id
  end
  
end
