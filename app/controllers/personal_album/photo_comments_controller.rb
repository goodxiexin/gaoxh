class PersonalAlbum::PhotoCommentsController < CommentsController

	before_filter :privilege_required, :only => [:create]

protected

  def catch_commentable
    @photo = PersonalPhoto.find(params[:personal_photo_id])
    @album = @photo.album
    @user = @album.user
    @commentable = @photo
		@privilege =@album.privilege
  rescue
    not_found
  end

end
