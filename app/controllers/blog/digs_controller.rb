class Blog::DigsController < Base::DigsController

protected

  def catch_diggable
    @blog = Blog.find(params[:blog_id])
    @diggable = @blog
  rescue
    not_found
  end

end
