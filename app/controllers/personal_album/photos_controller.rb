class PersonalAlbum::PhotosController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :privilege_required, :only => [:show]

  before_filter :owner_required, :only => [:new, :create, :edit, :update, :update_notation, :destroy, :edit_multiple, :update_multiple, :create_multiple]

	before_filter :friend_or_owner_required, :only => [:relative]

  def new
  end

  def show
    @comments = @photo.comments
  end

  def create_multiple
    @photos = []
    params[:photos].each do
      |attributes|  @photos << @album.photos.create(attributes.merge({:poster_id => current_user.id, :game_id => @album.game_id}))
    end
		# hack
		if @user.application_setting.emit_photo_feed
			item = @album.feed_items.create(:data => {:ids => @photos.map(&:id)})
			@album.poster.friends.each do |f|
				f.feed_deliveries.create(:feed_item_id => item.id) if f.application_setting.recv_photo_feed
			end
			@album.update_attribute('uploaded_at', Time.now)
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
          page << "if($('personal_photo_notation_#{@photo.id}'))$('personal_photo_notation_#{@photo.id}').innerHTML = '#{@photo.notation}';"
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

	# although this controller is about personal photo
	# hot photos can come from event album, guild album, avatar album as well
	def hot
		@photos = Photo.hot(params[:game_id]).paginate :page => params[:page], :per_page => 10
	end

	def relative
		@photos = Photo.relative_to(@user.id, params[:game_id]).paginate :page => params[:page], :per_page => 10
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
		elsif ['hot', 'relative'].include? params[:action]
			@user = User.find(params[:id])
    end
  rescue
    not_found
  end
end
