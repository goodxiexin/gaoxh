class MembershipFeedObserver < ActiveRecord::Observer

	observe :membership

	def after_update membership
		return unless membership.user.application_setting.emit_guild_feed
		return unless [3,4,5].include? membership.status
		item = membership.feed_items.create
		membership.user.profile.feed_deliveries.create(:feed_item_id => item.id)
		membership.user.friends.each do |f|
			f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_guild_feed
		end
	end

end
