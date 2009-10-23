class Vote < ActiveRecord::Base

  belongs_to :subscriber, :class_name => 'User'

  belongs_to :poll_answer

  belongs_to :poll

  def validate_on_create
    if poll.subscribers.include? subscriber
      errors.add_to_base('你已经投过票了')
    end
  end

end
