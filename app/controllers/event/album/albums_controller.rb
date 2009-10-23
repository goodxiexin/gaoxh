class Event::Album::AlbumsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  def show
    @participation = @event.participations.find_by_participant_id(current_user.id)
    @comments = @album.comments.user_viewable(current_user.id)
  end

  def update_description
    if @album.update_attributes(params[:album])
      render :text => @album.description
    end
  end

protected

  def setup
    @album = EventAlbum.find(params[:id])
    @event = @album.event
    @user = @event.poster
  rescue
    not_found
  end

end
