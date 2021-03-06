class BlogFeedObserver < ActiveRecord::Observer

	observe :blog

  def after_create(blog)
		return unless blog.poster.application_setting.emit_blog_feed
		item = blog.feed_items.create
		blog.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_blog_feed
		end
	end

  def after_update(blog)
		return unless blog.poster.application_setting.emit_blog_feed
		if blog.draft_was and !blog.draft
			item = blog.feed_items.create
			blog.poster.friends.each do |f|
				f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_blog_feed
			end
		end
  end

end
