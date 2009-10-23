class Comment < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :recipient, :class_name => 'User'

  belongs_to :commentable, :polymorphic => true, :counter_cache => true

  # comment content can contain emotion
  acts_as_emotion_text :columns => [:content]

  # named scope
  named_scope :user_viewable, lambda { |user_id|
    {:conditions => ["whisper = 0 OR poster_id = ? OR recipient_id = ?", user_id, user_id]}
  }

end
