class FriendTag < ActiveRecord::Base

  belongs_to :friend, :class_name => 'User'

  belongs_to :poster, :class_name => 'User'

  belongs_to :taggble, :polymorphic => true

  class TagNoneFriendError < StandardError; end

end


