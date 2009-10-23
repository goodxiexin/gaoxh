class Album::Photo::PhotosController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :privilege_required, :only => [:show]

  before_filter :owner_required, :only => [:new, :create, :edit, :update, :update_notation, :destroy, :edit_multiple, :update_multiple, :create_multiple]

  def new
  end

  def show
    @comments = @photo.comments.user_viewable(current_user.id)
  end

  def create_multiple
    @photos = []
    params[:photos].each do
      |attributes|  @photos << @album.photos.create(attributes)
    end
    redirect_to edit_multiple_personal_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id}) 
  end 

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    @album.update_attribute('cover_id', @photo.id) if params[:cover]
    if @photo.update_attributes(params[:photo])
      render :update do |page|
        if @photo.album_id_changed?
          page.redirect_to personal_photo_url(@photo)
        else
          page << "facebox.close();"
          page << "$('photo_notation_#{@photo.id}').innerHTML = '#{@photo.notation}';"
        end
      end 
    else
      # TODO
    end
  end

  def edit_multiple
  end

  def update_multiple
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    @photos.each {|photo| photo.update_attributes(params[:photos]["#{photo.id}"]) }
    redirect_to personal_album_url(@album) 
  end

  def destroy
    @photo.destroy
    render :update do |page|
      page.redirect_to personal_album_url(@album)
    end
  end

  def update_notation
    if @photo.update_attributes(params[:photo])
      render :text => @photo.notation
    end
  end

protected

  def setup
    if ['show', 'edit', 'update', 'update_notation', 'destroy'].include? params[:action]
      @photo = PersonalPhoto.find(params[:id])
      @album = @photo.album
      @user = @album.user
    elsif ['new', 'create_multiple'].include? params[:action]
      @user = current_user
      @album = PersonalAlbum.find(params[:album_id])
    elsif ['edit_multiple'].include? params[:action]
      @user = current_user
      @album = PersonalAlbum.find(params[:album_id])
      @photos = params[:ids].blank? ? [] : @album.photos.find(params[:ids])
    elsif ['update_multiple'].include? params[:action]
      @user = current_user
      @album = PersonalAlbum.find(params[:album_id])
      @photos = params[:photos].blank? ? [] : @album.photos.find(params[:photos].map {|id, attribute| id})
    end
  rescue
    not_found
  end
end
