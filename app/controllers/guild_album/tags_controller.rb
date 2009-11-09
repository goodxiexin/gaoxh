class GuildAlbum::TagsController < PhotoTagsController
	
	before_filter :member_required, :only => [:create]

protected

	def catch_photo
		@photo = GuildPhoto.find(params[:guild_photo_id])
		@album = @photo.album
		@guild = @album.guild
		@user = @album.poster
	rescue
		not_found
	end

	def member_required
		@guild.all_members.include?(current_user) || not_found
	end

end
