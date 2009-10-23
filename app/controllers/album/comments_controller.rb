class Album::CommentsController < Base::CommentsController

protected

  def catch_commentable
    @album = PersonalAlbum.find(params[:personal_album_id])
    @user = @album.user
    @commentable = @album
  rescue
    not_found
  end

end
