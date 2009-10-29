class Video::CommentsController < CommentsController

protected 

  def catch_commentable
    @video = Video.find(params[:video_id])
    @user = @video.poster
    @commentable = @video
  rescue
    not_found
  end

end
