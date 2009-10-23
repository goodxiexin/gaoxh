class Album < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  has_many :comments, :as => 'commentable', :order => 'created_at DESC', :dependent => :destroy

  # named scope
  named_scope :friend_viewable, 
              :conditions => ["privilege = 1 OR privilege = 2 OR privilege = 3"],
              :order => "created_at DESC"

  named_scope :same_game_viewable,
              :conditions => ["privilege = 1 OR privilege = 2"],
              :order => "created_at DESC"
 
  named_scope :owner_viewable,
              :order => "created_at DESC"
  
  named_scope :stranger_viewable,
              :conditions => ["privilege = 1"],
              :order => "created_at DESC"

  validate do |album|
    album.errors.add_to_base('标题不能为空') if album.title.blank?
    album.errors.add_to_base('请选择游戏类别') if album.game_id.blank?
    album.errors.add_to_base('标题最长100个字符') if album.title and album.title.length >= 100
    album.errors.add_to_base('描述最长500个字符') if album.description and album.description.length >= 500
  end

end
