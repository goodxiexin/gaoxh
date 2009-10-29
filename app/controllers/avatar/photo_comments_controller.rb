class Avatar::PhotoCommentsController < CommentsController

protected

  def catch_commentable
    @avatar = Avatar.find(params[:avatar_id])
    @album = @avatar.album
    @user = @album.user
    @commentable = @avatar
	rescue
		not_found
  end

end
