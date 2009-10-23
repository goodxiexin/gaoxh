class Album::Photo::CommentsController < Base::CommentsController

protected

  def catch_commentable
    @photo = PersonalPhoto.find(params[:personal_photo_id])
    @album = @photo.album
    @user = @album.user
    @commentable = @photo
  rescue
    not_found
  end

end
