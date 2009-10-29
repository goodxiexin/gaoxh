class PollInvitationObserver < ActiveRecord::Observer

	def after_create invitation
		PollMailer.deliver_invitation invitation.poll, invitation.user if invitation.user.mail_setting.invite_me_to_poll
	end

end
