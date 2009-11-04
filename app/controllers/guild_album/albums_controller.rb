class GuildAlbum::AlbumsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  def show
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    @comments = @album.comments
  end

  def update_description
    if @album.update_attributes(params[:album])
      render :text => @album.description
    end
  end

protected

  def setup
    @album = GuildAlbum.find(params[:id])
    @guild = @album.guild
    @user = @guild.president
  rescue
    not_found
  end

end
