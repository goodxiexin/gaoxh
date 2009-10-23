module Blog::BlogsHelper

  def blog_link blog
    link_to (truncate blog.title, :length => 20), blog_url(blog)
  end

end
