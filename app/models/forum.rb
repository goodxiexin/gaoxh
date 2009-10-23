class Forum < ActiveRecord::Base

  has_many :topics, :dependent => :delete_all

  has_many :posts

  belongs_to :guild

end
