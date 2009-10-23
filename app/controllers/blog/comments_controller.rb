class Blog::CommentsController < Base::CommentsController

  before_filter :owner_required, :only => [:destroy]

protected

  def catch_commentable
    @blog = Blog.find(params[:blog_id])
    @user = @blog.poster
    @commentable = @blog
  rescue
    not_found
  end 

  def owner_required
    @user == current_user || @comment.poster == current_user || not_found
  end

end
