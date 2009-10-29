module GlobalResources

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_global_resources opts={}

			cattr_accessor :gr_opts

			self.gr_opts = opts

      include GlobalResources::InstanceMethods

      extend GlobalResources::SingletonMethods
    end   

  end

  module SingletonMethods
		
		def viewable(relationship, game_id=nil)
			conditions = gr_opts[:conditions] || {}
			conditions.merge!({:game_id => game_id}) unless game_id.nil?
			case relationship
			when 'owner'
			when 'friend'
				conditions.merge!({:privilege => [1,2,3]})
			when 'same_game'
				conditions.merge!({:privilege => [1,2]})
			when 'stranger'
				conditions.merge!({:privilege => 1})
			end
			order = gr_opts[:order] || "created_at DESC"
			find(:all, :conditions => conditions, :order => order)	
		end

		def hot(game_id=nil)
			conditions = gr_opts[:conditions] || {}
      conditions.merge!({:game_id => game_id}) unless game_id.nil?
			order = gr_opts[:hot_order] || "digs_count DESC"
			find(:all, :conditions => conditions, :order => order)
		end

		def recent(game_id=nil)
			conditions = gr_opts[:conditions] || {}
      conditions.merge!({:game_id => game_id}) unless game_id.nil?
      order = gr_opts[:order] || "created_at DESC"
      find(:all, :conditions => conditions, :order => order)
		end

	end

  module InstanceMethods
  end

end

ActiveRecord::Base.send(:include, GlobalResources)

