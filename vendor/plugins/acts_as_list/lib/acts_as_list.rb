module ActsAsList

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
	
		def acts_as_list opts

			define_method("scope_name") do
				opts[:scope]
			end

			define_method("order_name") do
				opts[:order]
			end

			extend ActsAsList::SingletonMethods

			include ActsAsList::InstanceMethods

			type = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s

			define_method("acts_as_list_class") do
				type.constantize
			end

		end

	end

	module SingletonMethods
	end

	module InstanceMethods
		
		def next
			acts_as_list_class.find(:first, :conditions => ["#{scope_name} = ? AND #{order_name} > ?", eval("#{scope_name}"), eval("#{order_name}")], :order => "#{order_name} ASC") || acts_as_list_class.find(:first, :conditions => ["#{scope_name} = ?", eval("#{scope_name}")], :order => "#{order_name} ASC")
		end

		def prev
			acts_as_list_class.find(:first, :conditions => ["#{scope_name} = ? AND #{order_name} < ?", eval("#{scope_name}"), eval("#{order_name}")], :order => "#{order_name} DESC") || acts_as_list_class.find(:first, :conditions => ["#{scope_name} = ?", eval("#{scope_name}")], :order => "#{order_name} DESC")
		end
	
	end

end

ActiveRecord::Base.send(:include, ActsAsList)
