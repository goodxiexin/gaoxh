class FriendshipObserver < ActiveRecord::Observer

	def after_create friendship
		if friendship.status == 0
			# request was created
			FriendshipMailer.deliver_request(friendship.friend, friendship.user) if friendship.friend.mail_setting.request_to_be_friend
		end
	end

	def after_update friendship
		if friendship.status_was == 0 and friendship.status == 1
			# request was accepted
			friendship.user.notifications.create(:data => "#{profile_link friendship.friend}同意了你的好友请求") 
		end
	end

	def after_destroy friendship
		if friendship.status == 0
			# request was declined
			friendship.user.notifications.create(:data => "#{profile_link friendship.friend}决绝了你的好友请求")
		else
			# cancel friendship
			friendship.friend.notifications.create(:data => "你和#{profile_link friendship.user}的好友关系解除了")
		end
	end

end
