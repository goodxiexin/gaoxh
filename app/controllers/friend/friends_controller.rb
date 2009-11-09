class Friend::FriendsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

	before_filter :not_friend_required, :only => [:new]
	
  def index
    case params[:term].to_i
    when 0
      @friends = current_user.friends.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    when 1
      game = Game.find(params[:game_id])
      @friends = current_user.friends.find_all {|f| f.games.include?(game) }.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    when 2
			guild = Guild.find(params[:guild_id])
      @friends = current_user.friends.find_all {|f| f.participated_guilds.include?(guild) }.paginate :page => params[:page], :per_page => 12, :order => 'created_at DESC'
    end
  end

  def new
  end

  def destroy
    Friendship.transaction do
      Friendship.find(:first, :conditions => {:user_id => current_user.id, :friend_id => @friend.id}).destroy
      Friendship.find(:first, :conditions => {:user_id => @friend.id, :friend_id => current_user.id}).destroy
    end
    render :update do |page|
      page << "alert('成功');$('friend_#{params[:id]}').remove();"
    end
  end

  def search
    @friends = current_user.friends.find_all {|f| f.login.include?(params[:key]) }
    @friends = @friends.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    @remote = {:update => 'friends', :url => {:action => 'search', :key => params[:key]}}
    render :partial => 'friends', :object => @friends
  end

protected

  def setup
    if ["destroy"].include? params[:action]
      @friend = current_user.friends.find(params[:id])
    elsif ["new"].include? params[:action]
			@user = User.find(params[:id])
			@profile = @user.profile
		end
  rescue
    not_found
  end

	def not_friend_required
		if @user.has_friend? current_user
			redirect_to profile_url(current_user.profile)
		end
	end

end

