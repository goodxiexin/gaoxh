class CharactersController < ApplicationController

	before_filter :login_required, :setup

	def new
        @rating = 3
	end
	
	def create
		@character = current_user.characters.build(params[:character])
        @game = Game.find(params[:character][:game_id])
        Rating.delete_all(["rateable_type = 'Game' AND rateable_id = ? AND user_id = ?",  @game.id, current_user.id])
        @game.add_rating Rating.new(:rating => params[:game_rate], :user_id => current_user.id)
		if @character.save
			render :partial => 'character', :object => @character
		end
	end

	def edit
        @rating = @character.game.get_rating_from_user(current_user)
	end

	def update
        @game = Game.find(params[:character][:game_id])
        Rating.delete_all(["rateable_type = 'Game' AND rateable_id = ? AND user_id = ?",  @game.id, current_user.id])
        @game.add_rating Rating.new(:rating => params[:game_rate], :user_id => current_user.id)
		if @character.update_attributes(params[:character])
			render :partial => 'character', :object => @character
		end
	end

protected

	def setup
		if ["new", "create"].include? params[:action]
		elsif ["edit", "update"].include? params[:action]
			@character = current_user.characters.find(params[:id])
		end
	rescue
		not_found
	end

end
