class CommentsController < ApplicationController

  layout 'user'

  before_filter :login_required, :catch_commentable

  before_filter :catch_comment, :poster_or_owner_required, :only => [:destroy]

  def create
    @comment = @commentable.comments.build(params[:comment].merge({:user_id => current_user.id}))
    if @comment.save
      render :update do |page|
        page.insert_html :bottom, "comments_#{@commentable.class.to_s.underscore}_#{@commentable.id}", :partial => 'base/comments/comment', :object => @comment
 	page << "facebox.watchClickEvent($('delete_comment_#{@comment.id}'));"
        page << "$('comment_content_#{@commentable.class.to_s.underscore}_#{@commentable.id}').value = '';"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def destroy
    @comment.destroy
    render :update do |page|
      page << "facebox.close();$('comment_#{@comment.id}').remove();"
    end
  end

  def index
    @comments = @commentable.comments.find_user_viewable(current_user.id)
    render :partial => 'base/comments/comment', :collection => @comments
  end

protected

  def catch_commentable
    # implement this in your controllers
  end  

  def catch_comment
    @comment = @commentable.comments.find(params[:id])
  rescue
    not_found
  end

  def owner_required
    @user == current_user || @comment.user == current_user || owner_denied
  end

end
