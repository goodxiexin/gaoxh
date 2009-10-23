class Message < ActiveRecord::Base

  belongs_to :conversation, :counter_cache => true

  belongs_to :sender, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

  

end
