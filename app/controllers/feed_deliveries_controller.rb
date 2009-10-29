class FeedDeliveriesController < ApplicationController

	before_filter :login_required, :setup

	def destroy
		@feed_delivery.destroy
		render :update do |page|
			page << "$('feed_delivery_#{@feed_delivery.id}').remove();"
		end
	end

protected

	def setup
		@feed_delivery = current_user.feed_deliveries.find(params[:id])
	end

end
