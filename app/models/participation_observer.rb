class ParticipationObserver < ActiveRecord::Observer

	def after_create(participation)
		event = participation.event
		participant = participation.participant
		if participation.status == 0
			# invitation created
			EventMailer.deliver_invitation event, participant if participant.mail_setting.invite_me_to_event
		elsif participation.status == 1 or participation.status == 2
			# request created
			EventMailer.deliver_request event, participant if participant.mail_setting.request_to_attend_my_event
		end	
	end

	def after_update(participation)
		event = participation.event
		participant = participation.participant
		if participation.status_was == 0 and [3,4,5].include? participation.status
			# invitation accepted
			event.poster.notifications.create(:data => "#{profile_link participant}接受了你的邀请，加入活动#{event_link event}")
		elsif [1,2].include? participation.status_was and [3,4,5].include? participation.status
			# request accepted
			participant.notifications.create(:data => "#{profile_link event.poster}同意了你加入活动#{event_link event}的请求")
		elsif [3,4,5].include? participation.status_was and [3,4,5].include? participation.status
			# participant changes status
			# TODO: 是否有必要让poster知道
		end		
	end

	def after_destroy(participation)
		event = participation.event
		participant = participation.participant
		if [1,2].include? participation.status_was
			# request declined
			participant.notifications.create(:data => "#{profile_link event.poster}拒绝了你加入活动#{event_link event}的请求")
		end
	end

end
