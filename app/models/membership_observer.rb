class MembershipObserver < ActiveRecord::Observer

	def role status
		if status == 4
			"长老"
		elsif status == 5
			"普通会员"
		end
	end

	def after_create membership
		guild = membership.guild
		user = membership.user
		if membership.status == 0
			# invitation created
			GuildMailer.deliver_invitation guild, user if user.mail_setting.invite_me_to_guild
		elsif membership.status == 1 or membership.status == 2
			# request created
			GuildMailer.deliver_request guild, user if user.mail_setting.request_to_attend_my_guild
		end
	end

	def after_update membership
		guild = membership.guild
    user = membership.user
		if membership.status_was == 0 and [3,4,5].include? membership.status
			# invitation accepted
			guild.president.notifications.create(:data => "#{profile_link user}接受了你的邀请，参加工会#{guild_link guild}")
			user.decrement! :invitations_count
		elsif [1,2].include? membership.status_was and [3,4,5].include? membership.status
			# request accepted
			user.notifications.create(:data => "#{profile_link guild.president}同意你加入工会#{guild_link guild}的请求")
			guild.president.decrement! :requests_count
		elsif [4,5].include? membership.status_was and [4,5].include? membership.status and membership.status_changed?
			# nomination
			user.notifications.create(:data => "你在工会#{guild_link guild}里的职务更改为#{role membership.status}")
		end
	end

	def after_destroy membership
		guild = membership.guild
    user = membership.user
		if membership.status == 0
			# invitation declined
			guild.president.notifications.create(:data => "#{profile_link user}拒绝了你的邀请，参加工会#{guild_link guild}")
			user.decrement! :invitations_count
		elsif [1,2].include? membership.status
			# request declined
			user.notifications.create(:data => "#{profile_link guild.president}决绝你加入工会#{guild_link guil}的请求")
			guild.president.decrement! :requests_count
		end	
	end

end
