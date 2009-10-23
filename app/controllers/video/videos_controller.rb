class Video::VideosController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :update, :destroy]

  before_filter :friend_or_owner_required, :only => [:index]

  before_filter :privilege_required, :only => [:show]

  def index
    @videos = @user.videos.viewable(relationship, params[:game_id]).paginate :page => params[:page], :per_page => 10
  end

  def new
    @video = Video.new
  end

  def create
    if @video = @user.videos.create(params[:video].merge({:poster_id => current_user.id}))
      redirect_to video_url(@video)
    else
      render :action => 'new'
    end
  rescue Video::VideoURLNotValid
    @video.errors.add_to_base('url不对，我们只支持youku和tudou')
    render :action => 'new'
  rescue FriendTag::TagNoneFriendError
    render :text => 'error'
  end

  def show
    @comments = @video.comments.user_viewable(@user.id)
  end

  def edit
  end

  def update
    if @video.update_attributes(params[:video])
      redirect_to video_url(@video)
    else
      render :action => 'edit'
    end
  rescue FriendTag::TagNoneFriendError
    render :text => 'not friend'
  end

  def destroy
    @video.destroy
    render :update do |page|
      page.redirect_to videos_url(:id => @user.id)
    end
  end

  def hot
    @videos = Video.hot(params[:game_id]).paginate :page => params[:page], :per_page => 10
  end

  def recent
    @videos = Video.recent(params[:game_id]).paginate :page => params[:page], :per_page => 10
  end

protected

  def setup
    if ['index', 'hot', 'recent'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['new', 'create'].include? params[:action]
      @user = current_user
    elsif ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @video = Video.find(params[:id])
      @user = @video.poster
    end
  rescue
    not_found
  end

end
