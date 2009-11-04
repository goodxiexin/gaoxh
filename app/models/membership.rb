class Membership < ActiveRecord::Base

  belongs_to :user

  belongs_to :guild

	has_many :feed_items, :as => 'originator', :dependent => :destroy

	#has_conditional_counter :guild, :status, 
	#											 {:invitees_count => 0, :requestors_count => [1,2], :members_count => 5, :veterans_count => 4, :presidents_count => 3, :all_count => [3,4,5]}

	def before_create
		return if status == 3
		self.president_id = guild.president.id
	end

  def validate_on_create
    membership = guild.memberships.find_by_user_id(user_id)
    return true if membership.blank?
    if membership.status == 0
      errors.add_to_base('你已经被邀请了')
    elsif membership.status == 1 or participation.status == 2
      errors.add_to_base('你已经发送请求了')
    else
      errors.add_to_base('你已经加入了该工会')
    end
  end

end
