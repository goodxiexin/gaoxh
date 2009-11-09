class PersonalAlbum::TagsController < PhotoTagsController

	before_filter :privilege_required, :only => [:create]

protected

	def catch_photo
		@photo = PersonalPhoto.find(params[:personal_photo_id])
		@album = @photo.album
		@user = @album.poster
		@privilege = @album.privilege
	end

end
