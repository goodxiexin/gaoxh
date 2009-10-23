class Guild::Album::Photo::PhotosController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :president_or_veteran_required, :only => [:new, :create_multiple, :edit_multiple, :update_multiple]

  before_filter :owner_required, :only => [:edit, :update, :destroy]

  def new
  end

  def show
    @membership = @guild.memberships.find_by_participant_id(current_user.id)
    @comments = @photo.comments.user_viewable(current_user.id)
  end

  def create_multiple
    @photos = []
    params[:photos].each { |attributes|  @photos << @album.photos.create(attributes) }
    redirect_to edit_multiple_guild_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
  end 

  def edit
    render :action => 'edit', :layout => false 
  end

  def update
    @album.update_attribute('cover_id', @photo.id) if params[:cover]
    if @photo.update_attributes(params[:photo])
      render :update do |page|
        page << "facebox.close();"
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
    redirect_to guild_album_url(@album)
  end

  def destroy
    @photo.destroy
    render :update do |page|
      page.redirect_to guild_album_url(@album)
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
      @photo = GuildPhoto.find(params[:id])
      @album = @photo.album
      @guild = @album.guild
      @user = @guild.president
    elsif ['new', 'create_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      @user = @guild.president
    elsif ['edit_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      @user = @guild.president
      @photos = params[:ids].blank? ? [] : @album.photos.find(params[:ids])
    elsif ['update_multiple'].include? params[:action]
      @album = GuildAlbum.find(params[:album_id])
      @guild = @album.guild
      @user = @guild.president
      @photos = params[:photos].blank? ? [] : @album.photos.find(params[:photos].map {|id, attribute| id})
    end
  rescue
    not_found
  end

  def president_or_veteran_required
    @participation.status == 3 || @participation.status == 4 || not_found
  end 

end
