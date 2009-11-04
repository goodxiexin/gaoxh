class InvitationObserver < ActiveRecord::Observer

	observe :membership

	def after_create membership
		if membership.status == 0
			membership.user.increment! :invitations_count
		end	
	end

end
