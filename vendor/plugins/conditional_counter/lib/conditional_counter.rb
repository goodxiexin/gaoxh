module ConditionalCounter

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def has_conditional_counter cacher, field, mapping

			define_method("cacher") do
				eval("self.#{cacher}")
			end 

			define_method("field") do
				eval("self.#{field}")
			end

			define_method("field_was") do
				eval("self.#{field}_was")
			end

			define_method("mapping") do
				mapping
			end

			after_create :increment_counter

			after_update :update_counter

			after_destroy :decrement_counter

			include ConditionalCounter::InstanceMethods

			extend ConditionalCounter::SingletonMethods

		end

	end


  module SingletonMethods
  end

  module InstanceMethods

		def increment_counter
			mapping.each do |counter_name, value|
				if value.is_a? Array and value.include? field
					cacher.increment! counter_name
				elsif value == field
					cacher.increment! counter_name
				end
			end
		end

		def update_counter
			return if field == field_was
			mapping.each do |counter_name, value|
			  if value.is_a? Array and value.include? field
          cacher.increment! counter_name
        elsif value == field
          cacher.increment! counter_name
        end
			end
			mapping.each do |counter_name, value|
				if value.is_a? Array and value.include? field
          cacher.decrement! counter_name
        elsif value == field
          cacher.decrement! counter_name
        end
			end
		end

		def decrement_counter
			mapping.each do |counter_name, value|
			  if value.is_a? Array and value.include? field
          cacher.decrement! counter_name
        elsif value == field
          cacher.decrement! counter_name
        end
			end
		end

  end

end

ActiveRecord::Base.send(:include, ConditionalCounter)

