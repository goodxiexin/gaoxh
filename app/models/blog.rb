class Blog < ActiveRecord::Base

	belongs_to :poster, :class_name => 'User'

	acts_as_commentable :order => 'created_at ASC'

	acts_as_diggable

	acts_as_list :order => 'created_at', :scope => 'poster_id'

	acts_as_global_resources :conditions => {:draft => 0}

	has_conditional_counter :poster, :draft, {:blogs_count => false, :drafts_count => true}

	has_many :feed_items, :dependent => :destroy, :as => 'originator'

	has_many :tags, :class_name => 'FriendTag', :as => 'taggable', :dependent => :destroy

	has_many :relative_users, :through => :tags, :source => 'tagged_user'

  validate do |blog|
    blog.errors.add_to_base('标题不能为空') if blog.title.blank?
    blog.errors.add_to_base('请选择游戏类别') if blog.game_id.blank?
    blog.errors.add_to_base('标题最长100个字符') if blog.title.length >= 100
    blog.errors.add_to_base('内容最长10000个字符') if blog.content.length >= 10000
  end

	# virtual attribute tags
	# this is convenient for mass assignment
  def tags=(ids)
    poster.friends.find(ids).each { |f| tags.build(:tagged_user_id => f.id, :poster_id => poster_id) }
  end

end
