class Friendship < ActiveRecord::Base

  belongs_to :user

  belongs_to :friend, :class_name => 'User'

	has_many :feed_items, :as => 'originator', :dependent => :destroy

	def validate_on_create
		friendship = user.all_friendships.find_by_friend_id(friend_id)
		return if friendship.nil?
		if friendship.status == 0
			errors.add_to_base('你已经申请加他为好友了')
		elsif friendship.status == 1
			errors.add_to_base('你们已经是好友了')
		end
	end

	def accept
		update_attribute('status', 1)
		Friendship.create(:user_id => friend_id, :friend_id => user_id, :status => 1)
	end

end
