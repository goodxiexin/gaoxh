module ObserverLinkHelpers

	def event_link event
		"<a href='/events/#{event.id}'>#{event.title}</a>"
	end

	def profile_link user
		"<a href='/profiles/#{user.profile.id}'>#{user.login}</a>"
	end 

	def guild_link guild
		"<a href='/guilds/#{guild.president.id}'>#{guild.name}</a>"
	end

	def album_link album
		"<a href='/#{album.class.to_s.underscore}s/#{album.id}>#{album.title}</a>"
	end


end

ActiveRecord::Observer.send(:include, ObserverLinkHelpers)
