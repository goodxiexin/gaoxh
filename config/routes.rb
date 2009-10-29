ActionController::Routing::Routes.draw do |map|
  map.resources :users

  map.resources :sessions

  map.root :controller => 'sessions', :action => 'new' 

  map.signup '/signup', :controller => 'users', :action => 'new'

  map.login '/login', :controller => 'sessions', :action => 'new'

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'

  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'

  map.reset_password '/reset_password/:password_reset_code', :controller => 'passwords', :action => 'edit'
 
  map.home '/home', :controller => 'home', :action => 'show'

  map.resources :profiles, :controller => 'profile/profiles', :member => {:update_about_me => :put} do |profiles|
	
		profiles.resources :comments, :controller => 'profile/comments'

		profiles.resources :tags, :controller => 'profile/tags'

	end

	#
	# setting
	#
	map.resource :privacy_setting, :controller => 'setting/privacy_setting'

  map.resource :mail_setting, :controller => 'setting/mail_setting'

  map.resource :application_setting, :controller => 'setting/application_setting'

  map.resource :password_setting, :controller => 'setting/password_setting'

  #
  # games
  #
  map.resources :games, :member => {:game_details => :get, :area_details => :get}

	#
	# characters
	#
	map.resources :characters

  #
  # statuses
  #
  map.resources :statuses, :controller => 'status/statuses' do |statuses|
  
    statuses.resources :comments, :controller => 'status/comments'

  end

	map.resources :status_feeds, :controller => 'status/feeds'
 
  #
  # blogs
  #
  map.resources :blogs, :controller => 'blog/blogs', :collection => {:hot => :get, :recent => :get, :relative => :get} do |blogs|
    
    blogs.resources :comments, :controller => 'blog/comments'

    blogs.resources :digs, :controller => 'blog/digs'

    blogs.resources :tags, :controller => 'blog/tags'
  
  end

  map.resources :blog_feeds, :controller => 'blog/feeds'

  map.resources :drafts, :controller => 'blog/drafts'

  #
  # videos
  #
  map.resources :videos, :controller => 'video/videos', :collection => {:hot => :get, :recent => :get, :relative => :get} do |blogs|

    blogs.resources :comments, :controller => 'video/comments'

    blogs.resources :digs, :controller => 'video/digs'

    blogs.resources :tags, :controller => 'video/tags'

  end

	map.resources :video_feeds, :controller => 'video/feeds'

  #
  # avatar album
  #
  map.resources :avatar_albums, :controller => 'avatar/albums' do |albums|
 
    albums.resources :comments, :controller => 'avatar/album_comments'
 
  end

  map.resources :avatars, :controller => 'avatar/photos', :member => {:set => :post, :update_notation => :put} do |avatars|

    avatars.resources :comments, :controller => 'avatar/photo_comments'

    avatars.resources :tags, :controller => 'avatar/tags'

    avatars.resources :digs, :controller => 'avatar/digs'

  end

  #
  # personal album
  #
  map.resources :personal_albums, :controller => 'personal_album/albums', :member => {:confirm_destroy => :get, :update_description => :put}, 
                :collection => {:hot => :get, :recent => :get, :select => :get} do |albums|
  
    albums.resources :comments, :controller => 'personal_album/album_comments'

  end

  map.resources :personal_photos, :controller => 'personal_album/photos', :member => {:cover => :post, :update_notation => :put},
                :collection => {:hot => :get, :update_multiple => :put, :edit_multiple => :get, :create_multiple => :post, :relative => :get} do |photos|

    photos.resources :comments, :controller => 'personal_album/comments'

    photos.resources :tags, :controller => 'personal_album/tags'

    photos.resources :digs, :controller => 'personal_album/digs'

  end

	map.resources :album_feeds, :controller => 'personal_album/feeds'

  #
  # event
  #
  map.resources :events, :controller => 'event/events', 
                :collection => {:hot => :get, :recent => :get, :upcoming => :get, :participated => :get, :search => :get} do |events|
    
    events.resources :participations, :controller => 'event/participations'

    events.resources :comments, :controller => 'event/comments'

    events.resources :invitations, :controller => 'event/invitations', :member => {:accept => :put, :decline => :put},
                     :collection => {:create_multiple => :post, :search => :get}

    events.resources :requests, :controller => 'event/requests', :member => {:accept => :put, :decline => :delete}

  end
               
  map.resources :event_albums, :controller => 'event_album/albums', :member => {:update_description => :put} do |albums|

    albums.resources :comments, :controller => 'event_album/album_comments'
 
  end

  map.resources :event_photos, :controller => 'event_album/photos', :member => {:update_notation => :put},
                :collection => {:create_multiple => :post, :update_multiple => :put, :edit_multiple => :get} do |photos|

    photos.resources :comments, :controller => 'event_album/photo_comments'

    photos.resources :digs, :controller => 'event_album/digs'

    photos.resources :tags, :controller => 'event_album/tags'

  end

	map.resources :event_feeds, :controller => 'event/feeds'

  #
  # polls
  #
  map.resources :polls, :controller => 'poll/polls', :collection => {:hot => :get, :recent => :get, :participated => :get} do |polls|

    polls.resources :invitations, :controller => 'poll/invitations', :collection => {:search => :get, :create_multiple => :post}

    polls.resources :answers, :controller => 'poll/answers'

    polls.resources :votes, :controller => 'poll/votes'

    polls.resources :comments, :controller => 'poll/comments'

  end

	map.resources :poll_feeds, :controller => 'poll/feeds'

  #
  # guild
  #
  map.resources :guilds, :controller => 'guild/guilds', :collection => {:hot => :get, :recent => :get, :search => :get} do |guilds|

    guilds.resources :memberships, :controller => 'guild/memberships', :collection => {:search => :get}

    guilds.resources :comments, :controller => 'guild/comments'

    guilds.resources :friends, :controller => 'guild/friends'

    guilds.resources :requests, :controller => 'guild/requests', :member => {:accept => :put, :decline => :delete}

    guilds.resources :invitations, :controller => 'guild/invitations', :collection => {:create_multiple => :post, :search => :get},
                     :member => {:accept => :put, :decline => :delete}

    guilds.resources :events, :controller => 'guild/events', :collection => {:search => :get}
  
	end

  map.resources :guild_albums, :controller => 'guild_album/albums', :member => {:update_description => :put} do |albums|

		albums.resources :comments, :controller => 'guild_album/album_comments'

	end

  map.resources :guild_photos, :controller => 'guild_album/photos',
                :collection => {:create_multiple => :post, :update_multiple => :put, :edit_multiple => :get},
                :member => {:update_notation => :put, :cover => :post} do |photos|

    photos.resources :comments, :controller => 'guild_album/photo_comments'

    photos.resources :tags, :controller => 'guild_album/tags'

    photos.resources :digs, :controller => 'guild_album/digs'
  
	end
               
  map.resources :guild_feeds, :controller => 'guild/feeds' 

	#
	# forum
	#
	map.resources :forums, :controller => 'forum/forums' do |forums|
	
	  forums.resources :topics, :controller => 'forum/topics', :member => {:toggle => :put} do |posts|
  
	    posts.resources :posts, :controller => 'forum/posts'
	
	  end
  
	end

  #
  # friends
  #
  map.resources :friends, :controller => 'friend/friends', :collection => {:search => :get} 

  map.resources :someone_friends, :controller => 'friend/someone_friends'

  map.resources :friend_requests, :controller => 'friend/requests', :member => {:accept => :delete, :destroy => :delete}

	map.resources :friend_impressions, :controller => 'friend/impressions'

	#
	# requests and invitations
	#
	map.resources :requests

	map.resources :invitations

	map.resources :notifications

	map.resources :mails, :member => {:reply => :post}

	map.resources :pokes, :collection => {:destroy_all => :delete}

	#
	# feeds
	#
	map.resources :feed_deliveries
  
	map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
