class VideoFeedObserver < ActiveRecord::Observer

	observe :video

	def after_create(video)
		return unless video.poster.application_setting.emit_video_feed
		item = video.feed_items.create
		video.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_video_feed
		end
	end

end
