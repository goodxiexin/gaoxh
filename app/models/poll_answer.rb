class PollAnswer < ActiveRecord::Base

  belongs_to :poll, :counter_cache => :answers_count

  has_many :votes, :dependent => :destroy

  has_many :subscribers, :through => :votes 

end
