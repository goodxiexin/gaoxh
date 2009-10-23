class Avatar::Photo::PhotosController < ApplicationController

  layout 'user'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :set, :update, :confirm_destroy, :destroy]

  before_filter :privilege_required, :only => [:show]

  def show
    @comments = @photo.comments.user_viewable(current_user.id)
  end

  def new
    render :action => 'new', :layout => false
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def create
    if @photo = @album.photos.create(params[:photo]) and @user.update_attribute('avatar_id', @photo.id) 
      responds_to_parent do
        render :update do |page|
          page << "facebox.close()"
          if params[:album].to_i == 1
            page.redirect_to avatar_album_url(@album)
          else
            page.replace_html 'user_icon', avatar(@user, :medium)
          end
        end
      end
    else
      responds_to_parent do
        render :update do |page|
          page << "$('error').innerHTML = 'There was an error uploading this icon"
        end
      end
    end
  end

  def set
    @user.update_attribute('avatar_id', @photo.id)
    flash[:notice] = "修改成功"
    render :update do |page|
      page.redirect_to avatar_album_url(@album)
    end
  end

  def update
    if @photo.update_attributes(params[:photo])
      render :update do |page|
        page << "facebox.close();"
      end
    else
      flash.now[:error] = "There was an error updating this icon"
      render :action => 'edit'
    end
  end

  def destroy
    @photo.destroy
    flash[:notice] = "删除成功"
    render :update do |page|
      page.redirect_to avatar_album_url(@album)
    end
  end

protected

  def setup
    if ['show', 'edit', 'set', 'update', 'destroy'].include? params[:action]
      @photo = Avatar.find(params[:id])
      @album = @photo.album
      @user = @album.user
    elsif ['new', 'create'].include? params[:action]
      @user = current_user
      @album = @user.avatar_album
    end
  rescue
    not_found 
  end

end
