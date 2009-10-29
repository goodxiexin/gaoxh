class Guild::GuildsController < ApplicationController

  layout 'user'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :update]

  def index
    @guilds = @user.participated_guilds.paginate :page => params[:page], :per_page => 10
  end

  def show
    @comments = @guild.comments.user_viewable(current_user.id).paginate :page => 1, :per_page => 10
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    @album = @guild.album
  end

  def new
  end

  def create
    @guild = Guild.new(params[:guild].merge({:president_id => current_user.id}))# virtual attribute
    if @guild.save
      @guild.album.create_cover(params[:photo]) unless params[:photo].blank?
      redirect_to guild_url(@guild)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @guild.update_attributes(params[:guild])
      redirect_to guild_url(@guild)
    else
      render :action => 'edit'
    end
  end

  def hot
    @guilds = Guild.hot(params[:game_id]).paginate :page => params[:page], :per_page => 10
  end

  def recent
    @guilds = Guild.recent(params[:game_id]).paginate :page => params[:page], :per_page => 10
  end

  def search
    case params[:type].to_i
    when 1
      guilds = Guild.find(:all, :conditions => game_conditions, :order => 'members_count DESC')
    when 2
      guilds = Guild.find(:all, :conditions => game_conditions, :order => 'created_at DESC')
    end
    @guilds = guilds.find_all {|g| g.name.include?(params[:key])}.paginate :page => params[:page], :per_page => 5
    @remote = {:update => 'guilds', :url => {:action => 'search', :controller => 'guild/guilds', :type => params[:type], :key => params[:key]}}
    render :partial => 'guild/guilds', :object => @guilds
  end

protected

  def setup
    if ['index', 'hot', 'recent'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['show', 'edit', 'update'].include? params[:action]
      @guild = Guild.find(params[:id])
      @user = @guild.president
		elsif ['new', 'create'].include? params[:action]
			@user = current_user
    end
  rescue
    not_found
  end

end
