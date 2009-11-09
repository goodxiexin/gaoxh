class Conversation < ActiveRecord::Base

	has_many :messages, :order => 'created_at DESC'

	belongs_to :sender, :class_name => 'User'

	belongs_to :recipient, :class_name => 'User'

end
