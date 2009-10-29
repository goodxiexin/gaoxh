class GamesController < ApplicationController

  before_filter :login_required, :setup

  def game_details
		unless @game.no_areas?
			render :json => {:no_areas => false, :areas => @game.areas, :professions => @game.professions, :races => @game.races}
		else
			render :json => {:no_areas => true, :servers => @game.servers, :professions => @game.professions, :races => @game.races}
		end
	end

	def area_details
		render :json => @area.servers
	end

protected

  def setup
    if ["game_details"].include? params[:action]
      @game = Game.find(params[:id])
    elsif ["game_details", "area_details"].include? params[:action]
			@game = Game.find(params[:id])
			@area = GameArea.find(params[:area_id])
		end
  rescue
    not_found
  end

end
