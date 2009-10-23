class Blog::BlogsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :friend_or_owner_required, :only => [:index]

  before_filter :privilege_required, :only => [:show]

  before_filter :owner_required, :only => [:edit, :update, :destroy]

  def index
    @blogs = @user.blogs.viewable(relationship, params[:game_id]).paginate :page => params[:page], :per_page => 10 
  end

  def show
    @comments = @blog.comments.user_viewable(current_user.id)
  end

  def new
    @blog = Blog.new
  end

  def create
    if @blog = @user.blogs.create(params[:blog].merge({:poster_id => @user.id, :draft => false}))
      redirect_to blog_url(@blog)
    else
      render :action => 'new'
    end
  rescue FriendTag::TagNoneFriendError
    render :text => '只能标记你的朋友'
  end

  def edit
  end

  # TODO: what if tags are stored while blog's validation fails
  def update
    if @blog.update_attributes(params[:blog].merge({:draft => false}))
      redirect_to blog_url(@blog)
    else
      render :action => 'edit'
    end
  rescue Blog::TagNoneFriendError
    render :text => '只能标记你的朋友'
  end

  def destroy
    @blog.destroy
    render :update do |page|
      page.redirect_to blogs_url(:id => @user.id)
    end
  end

  def hot
    @blogs = Blog.hot(params[:game_id]).paginate :page => params[:page], :per_page => 10
  end

  def recent
    @blogs = Blog.recent(params[:game_id]).paginate :page => params[:page], :per_page => 10
  end

protected

  def setup
    if ['index', 'hot', 'recent'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['new', 'create', 'hot', 'recent'].include? params[:action]
      @user = current_user
    elsif ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @blog = Blog.find(params[:id])
      @user = @blog.poster
    end
  rescue
    not_found
  end

end
