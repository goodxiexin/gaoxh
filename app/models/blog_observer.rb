# this obersver is to main blog counter and draft counter
class BlogObserver < ActiveRecord::Observer

  def after_create(blog)
    counter = (blog.draft)? 'drafts_count' : 'blogs_count'
    blog.poster.increment! counter
  end

  def after_update(blog)
    # from draft to blog
    if !blog.draft and blog.draft_was
      blog.poster.decrement! 'drafts_count'
      blog.poster.increment! 'blogs_count'
    end
  end

  def after_destroy(blog)
    counter = (blog.draft)? 'drafts_count' : 'blogs_count'
    blog.poster.decrement! counter
  end

end
