class Status < ActiveRecord::Base

  belongs_to :user, :counter_cache => true

  has_many :comments, :as => 'commentable', :dependent => :destroy

  acts_as_emotion_text :columns => [:content]

end
