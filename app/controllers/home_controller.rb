class HomeController < ApplicationController

  layout 'app'

  before_filter :login_required

  TimeRange = [{:from => 1, :to => 0}, # today
               {:from => 7, :to => 1},
               {:from => 30, :to => 7}]

	FeedCategory = [['Status'], ['Blog'], ['Video'], ['Photo', 'Album'], ['Event', 'Participation'], ['Poll', 'Vote'], ['Guild', 'Membership']]

  def show
		@idx = 0 
    while @idx < TimeRange.count and @feed_deliveries.blank?
      parse_and_increment_idx
      @feed_deliveries = current_user.feed_deliveries.find(:all, :conditions => ["created_at BETWEEN ? AND ?", @from, @to])
    end
	end

	def feeds
		@idx = 0
    while @idx < TimeRange.count and @feed_deliveries.blank?
      parse_and_increment_idx
      @feed_deliveries = current_user.feed_deliveries.find(:all, :conditions => ["created_at BETWEEN ? AND ?", @from, @to])
    end
		unless params[:type].blank?
			@feed_deliveries = @feed_deliveries.find_all {|d| FeedCategory[params[:type].to_i].include? d.feed_item.originator_type }
		end
	end

	def more_feeds
		@idx = params[:range_id].to_i
		while @idx < TimeRange.count and @feed_deliveries.blank? 
			parse_and_increment_idx
			@feed_deliveries = current_user.feed_deliveries.find(:all, :conditions => ["created_at BETWEEN ? AND ?", @from, @to])
		end
		unless params[:type].blank?
      @feed_deliveries = @feed_deliveries.find_all {|d| FeedCategory[params[:type].to_i].include? d.feed_item.originator_type }
    end
	end

protected

  def parse_and_increment_idx
    @from = (TimeRange[@idx][:from] == 0)? '2000-1-1' : TimeRange[@idx][:from].days.ago.beginning_of_day.to_s(:db)
    @to = (TimeRange[@idx][:to] == 0)? Time.now.to_s(:db) : TimeRange[@idx][:to].days.ago.beginning_of_day.to_s(:db)
    @idx = @idx + 1
  end

end
