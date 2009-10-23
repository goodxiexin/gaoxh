class Base::FriendTagsController < ApplicationController

  def games_list
    render :partial => 'games_list', :object => current_user.games
  end

  def friends_list
    if params[:game_id] == 'all'
      @friends = current_user.friends
    else
      game = Game.find(params[:game_id])
      @friends = current_user.friends.find_all {|f| f.games.include?(game) }
    end
    render :partial => 'friends_list', :object => @friends
  end

  def friends_auto_complete
    @friends = current_user.friends.find_all {|f| f.login.include?(params[:user][:login]) }
    render :partial => 'friends' 
  end

end
