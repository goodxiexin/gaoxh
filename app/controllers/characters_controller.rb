class CharactersController < ApplicationController

	before_filter :login_required, :setup

	def new
	end
	
	def create
		@character = current_user.characters.build(params[:character])
		if @character.save
			render :partial => 'character', :object => @character
		end
	end

	def edit
	end

	def update
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
