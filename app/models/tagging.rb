class Tagging < ActiveRecord::Base

	belongs_to :taggable, :polymorphic => true

	belongs_to :tag, :counter_cache => true

	belongs_to :poster, :class_name => 'User'

  def after_destroy
    if Tag.destroy_unused
      if tag.taggings.count.zero?
        tag.destroy
      end
    end
  end
end
