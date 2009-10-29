class Video < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User', :counter_cache => true

  belongs_to :game

	acts_as_commentable :order => 'created_at ASC'

	acts_as_friend_taggable :class_name => 'FriendTag'

	acts_as_diggable

  acts_as_list :order => 'created_at', :scope => 'poster_id'
 
	acts_as_global_resources

	has_many :feed_items, :dependent => :destroy, :as => 'originator'
 
  validate do |video|
    video.errors.add_to_base('标题不能为空') if video.title.blank?
    video.errors.add_to_base('url不能为空') if video.url.blank?
    video.errors.add_to_base('游戏类别不能为空') if video.game_id.blank?
    video.errors.add_to_base('标题太长，最长100个字符') if video.title and video.title.length >= 100
  end

	before_create :generate_link

  class VideoURLNotValid < StandardError; end

  def generate_link
    if (url =~ /youku\.com/)
      startPos = (url =~ /\/id_/)
      videoId = url[(startPos + 4)..-6]
      videoUrl = "http://player.youku.com/player.php/sid/"+ videoId +"/v.swf"
      self.link = "<embed src=\""+ videoUrl + "\" quality=\"high\" width=\"480\" height=\"400\" align=\"middle\" allowScriptAccess=\"sameDomain\" type=\"application/x-shockwave-flash\"></embed>"
    elsif (url =~ /tudou\.com/)
      startPos = (url =~ /view\//)
      videoId = url[(startPos + 5)..-2]
      videoUrl = "http://www.tudou.com/v/"+videoId
      self.link = "<object width=\"420\" height=\"363\"><param name=\"movie\" value=\""+ videoUrl +"\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><param name=\"wmode\" value=\"opaque\"></param><embed src=\""+ videoUrl+"\"type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" allowfullscreen=\"true\" wmode=\"opaque\" width=\"420\" height=\"363\"></embed></object>"
    else
      raise VideoURLNotValid    
    end
  end
 
  def tags=(ids)
    poster.friends.find(ids).each { |f| tags.build(:poster_id => poster_id, :friend_id => f.id) }
  rescue
    raise FriendTag::TagNoneFriendError
  end

end
