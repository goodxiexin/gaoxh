class Comment < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

  belongs_to :commentable, :polymorphic => true, :counter_cache => true

	has_many :notifications, :as => 'notifier', :dependent => :destroy

  acts_as_emotion_text :columns => [:content]

end
