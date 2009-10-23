class Friend::FriendsController < ApplicationController

  layout 'user'

  before_filter :login_required, :setup

  def index
    case params[:term].to_i
    when 0
      @friends = current_user.friends.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    when 1
      game = Game.find(params[:game_id])
      @friends = current_user.friends.find_all {|f| f.profile.games.include?(game) }.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    when 2
      @friends = current_user.friends.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
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
    @friends = @friends.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    @remote = {:update => 'friends', :url => {:action => 'search', :key => params[:key]}}
    render :partial => 'friends', :object => @friends
  end

protected

  def setup
    @user = current_user
    @profile = @user.profile
    if ["destroy", "new"].include? params[:action]
      @friend = @user.friends.find(params[:id])
    end
  rescue
    not_found
  end

end
