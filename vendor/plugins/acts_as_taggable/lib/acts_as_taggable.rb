# ActsAsTaggable
module Taggable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_taggable

      has_many :taggings, :as => 'taggable', :dependent => :destroy

			has_many :tags, :through => :taggings, :uniq => true

      include Taggable::InstanceMethods

      extend Taggable::SingletonMethods
    end   

  end

  module SingletonMethods
  end

  module InstanceMethods

		def tag_list
			tags.map(&:name).join(',')
		end

		def tag_list=(value)
			value.split(%r{,\s*}).each do |tag_name|
				tag = Tag.find_or_create_by_name(tag_name)
        taggings.create(:tag_id => tag.id)
			end
		end

		def tagged_by? user
			taggings.find_by_poster_id(user.id)
		end

  end

end

ActiveRecord::Base.send(:include, Taggable)

