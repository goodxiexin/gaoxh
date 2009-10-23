class GamesController < ApplicationController

  before_filter :login_required, :setup

  def show
    render :json => @game.areas
  end

protected

  def setup
    if ["show"].include? params[:action]
      @game = Game.find(params[:id])
    end
  rescue
    not_found
  end

end
