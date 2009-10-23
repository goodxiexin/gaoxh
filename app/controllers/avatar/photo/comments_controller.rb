class Avatar::Photo::CommentsController < ApplicationController

protected

  def catch_commentable
    @avatar = Avatar.find(params[:id])
    @album = @avatar.album
    @user = @album.user
    @commentable = @avatar
  rescue
    not_found
  end

end
