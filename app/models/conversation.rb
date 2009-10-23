class Conversation < ActiveRecord::Base

  belongs_to :initiator, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

  has_many :messages, :order => 'created_at ASC', :dependent => :destroy


end
