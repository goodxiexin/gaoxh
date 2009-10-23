class Avatar::AlbumsController < ApplicationController

  layout 'user'

  before_filter :login_required, :setup, :friend_or_owner_required

  def show
    @photos = @album.photos.paginate :page => params[:page], :per_page => 16
    @comments = @album.comments.user_viewable(current_user.id)
  end

protected

  def setup
    @album = AvatarAlbum.find(params[:id])
    @user = @album.user
  rescue
    not_found
  end

end
