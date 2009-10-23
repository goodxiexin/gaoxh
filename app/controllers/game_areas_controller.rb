class GameAreasController < ApplicationController

  before_filter :login_required, :setup

  def show
    render :json => @area.servers
  end

protected

  def setup
    if ["show"].include? params[:action]
      @area = GameArea.find(params[:id])
    end
  rescue
    not_found
  end

end
