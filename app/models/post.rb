class Post < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :forum, :counter_cache => true

  belongs_to :topic, :counter_cache => true


end
