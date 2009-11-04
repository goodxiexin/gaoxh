class VoteFeedObserver < ActiveRecord::Observer

	observe :vote

	def after_create vote
		return unless vote.voter.application_setting.emit_poll_feed
		item = vote.feed_items.create
		vote.voter.profile.feed_deliveries.create(:feed_item_id => item.id)
		vote.voter.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_poll_feed
		end
	end

end
