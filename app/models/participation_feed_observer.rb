class ParticipationFeedObserver < ActiveRecord::Observer

	observe :participation

	def after_update(participation)
		return unless participation.participant.application_setting.emit_event_feed
		return unless [4,5].include? participation.status
		item = participation.feed_items.create
		participation.participant.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_event_feed
		end
	end

end
