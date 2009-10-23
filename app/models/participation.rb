class Participation < ActiveRecord::Base

  belongs_to :participant, :class_name => 'User'

  belongs_to :event

  def validate_on_create
    participation = event.participations.find_by_participant_id(participant_id)
    return true if participation.blank?
    if participation.status == 0
      errors.add_to_base('你已经被邀请了') 
    elsif participations.status == 1 or participation.status == 2
      errors.add_to_base('你已经发送请求了')
    else
      errors.add_to_base('你已经参加了该活动')
    end
  end

end
