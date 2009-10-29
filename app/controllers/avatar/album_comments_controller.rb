class Avatar::AlbumCommentsController < CommentsController

protected

  def catch_commentable
    @album = AvatarAlbum.find(params[:avatar_album_id])
    @user = @album.user
    @commentable = @album
  rescue
		not_found
	end

end
