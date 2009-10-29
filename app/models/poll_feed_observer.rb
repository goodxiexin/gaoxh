class PollFeedObserver < ActiveRecord::Observer

	observe :poll

  def after_create(poll)
		return unless poll.poster.application_setting.emit_poll_feed
		item = poll.feed_items.create
		poll.poster.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_poll_feed
		end
	end

end
