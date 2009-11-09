class GamesController < ApplicationController

  before_filter :login_required, :setup

  def game_details
        if (@game.servers_count > 0)
           @temp = false
        else
           @temp = true
        end
	    render :json => {:no_areas => @game.no_areas, :no_races => @game.no_races, :no_professions => @game.no_professions, :no_servers => @temp, :areas => @game.areas, :professions => @game.professions, :races => @game.races}
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
