class Profile < ActiveRecord::Base

	MAX_VISITOR_RECORDS = 9

  belongs_to :user

	belongs_to :country

	belongs_to :province

	belongs_to :city

	acts_as_commentable :order => 'created_at DESC'

	acts_as_taggable

	has_many :feed_items, :as => 'originator', :dependent => :destroy

	has_many :visitor_records, :order => 'created_at DESC'

end

