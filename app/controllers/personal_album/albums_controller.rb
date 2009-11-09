class PersonalAlbum::AlbumsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:select, :edit, :update, :update_description, :confirm_destroy, :destroy]

  before_filter :friend_or_owner_required, :only => [:index]

  def index
    @albums = @user.albums.viewable(relationship, params[:game_id]).push @user.avatar_album
		@albums = @albums.paginate :page => params[:page], :per_page => 10
  end

  def select
    @albums = @user.albums
  end

  def show
		@comments = @album.comments 
  end

  def new
    @album = PersonalAlbum.new
    render :action => 'new', :layout => false
  end

  def create
    @album = @user.albums.build(params[:album].merge({:poster_id => @user.id}))
    if @album.save
      render :update do |page|
        page.redirect_to personal_albums_url(:id => @user.id)
      end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'validation_errors'
      end
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @album.update_attributes(params[:album])
      render :update do |page|
        page.alert '成功'
      end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'validation_errors'
      end
    end
  end 

  def update_description
    if @album.update_attribute('description', params[:album][:description])
      render :text => @album.description
    end
  end

  def confirm_destroy
    render :action => 'confirm_destroy', :layout => false
  end

  def destroy
    if params[:migration] and params[:migration].to_i == 1 and !params[:album][:id].blank?
      Photo.update_all("album_id = #{params[:album][:id]}", "album_id = #{@album.id}")
    end
    @album.destroy
		render :update do |page|
			page.redirect_to personal_albums_url(:id => @user.id)  
		end
	end

  def update_description
    if @album.update_attributes(params[:album])
      render :text => @album.description
    end
  end

	def recent
		@albums = PersonalAlbum.recent(params[:game_id]).paginate :page => params[:page], :per_page => 10
	end

protected

  def setup
    if ["index", "recent", "select"].include? params[:action]
      @user = User.find(params[:id])
    elsif ["show", "edit", "update", "update_description", "confirm_destroy", "destroy"].include? params[:action]
      @album = PersonalAlbum.find(params[:id])
      @user = @album.user
    elsif ["new", "create"].include? params[:action]
      @user = current_user
    end
  rescue
    not_found
  end

end
