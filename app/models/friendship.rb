class Friendship < ActiveRecord::Base

  belongs_to :user

  belongs_to :friend, :class_name => 'User'

  acts_as_enumeration :status => [:pending, :accepted, :intimate]

end
