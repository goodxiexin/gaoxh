class Membership < ActiveRecord::Base

  belongs_to :user

  belongs_to :guild, :counter_cache => :members_count

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
