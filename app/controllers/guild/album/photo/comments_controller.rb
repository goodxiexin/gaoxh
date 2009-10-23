class Guild::Album::Photo::CommentsController < Base::CommentsController

protected

  def catch_commentable
    @photo = GuildPhoto.find(params[:guild_photo_id])
    @album = @photo.album
    @guild = @album.guild
    @user = @guild.president
    @commentable = @photo
  rescue
    not_found
  end


end
