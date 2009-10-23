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

  map.resources :profiles, :controller => 'profile/profiles' do |profiles|
	
		profiles.resources :comments, :controller => 'profile/comments'

	end

  #
  # games
  #
  map.resources :games

  #
  # game areas 
  #
  map.resources :game_areas

  #
  # statuses
  #
  map.resources :statuses, :controller => 'status/statuses' do |statuses|
  
    statuses.resources :comments, :controller => 'status/comments'

  end
 
  #
  # blogs
  #
  map.resources :blogs, :controller => 'blog/blogs', :collection => {:hot => :get, :recent => :get} do |blogs|
    
    blogs.resources :comments, :controller => 'blog/comments'

    blogs.resources :digs, :controller => 'blog/digs'

    blogs.resources :tags, :controller => 'blog/tags'
  
  end

  map.resources :relative_blogs, :controller => 'blog/relative_blogs'

  map.resources :friend_blogs, :controller => 'blog/friend_blogs'

  map.resources :drafts, :controller => 'blog/drafts'

  #
  # videos
  #
  map.resources :videos, :controller => 'video/videos', :collection => {:hot => :get, :recent => :get} do |blogs|

    blogs.resources :comments, :controller => 'video/comments'

    blogs.resources :digs, :controller => 'video/digs'

    blogs.resources :tags, :controller => 'video/tags'

  end

  #
  # avatar album
  #
  map.resources :avatar_albums, :controller => 'avatar/albums' do |albums|
 
    albums.resources :comments, :controller => 'avatar/comments'
 
  end

  map.resources :avatars, :controller => 'avatar/photo/photos', :member => {:confirm_destroy => :get, :set => :post} do |avatars|

    avatars.resources :comments, :controller => 'avatar/photo/comments'

    avatars.resources :tags, :controller => 'avatar/photo/tags'

    avatars.resources :digs, :controller => 'avatar/photo/digs'

  end

  #
  # personal album
  #
  map.resources :personal_albums, :controller => 'album/albums', :member => {:confirm_destroy => :get, :update_description => :put}, 
                :collection => {:hot => :get, :recent => :get, :select => :get} do |albums|
  
    albums.resources :comments, :controller => 'album/comments'

  end

  map.resources :personal_photos, :controller => 'album/photo/photos', :member => {:cover => :post, :update_notation => :put},
                :collection => {:update_multiple => :put, :edit_multiple => :get, :create_multiple => :post} do |photos|

    photos.resources :comments, :controller => 'album/photo/comments'

    photos.resources :tags, :controller => 'album/photo/tags'

    photos.resources :digs, :controller => 'album/photo/digs'

  end

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
               
  map.resources :event_albums, :controller => 'event/album/albums', :member => {:update_description => :put} do |albums|

    albums.resources :comments, :controller => 'event/album/comments'
 
  end

  map.resources :event_photos, :controller => 'event/album/photo/photos', :member => {:update_notation => :put},
                :collection => {:create_multiple => :post, :update_multiple => :put, :edit_multiple => :get} do |photos|

    photos.resources :comments, :controller => 'event/album/photo/comments'

    photos.resources :digs, :controller => 'event/album/photo/digs'

    photos.resources :tags, :controller => 'event/album/photo/tags'

  end

  #
  # polls
  #
  map.resources :polls, :controller => 'poll/polls', :collection => {:hot => :get, :recent => :get, :participated => :get} do |polls|

    polls.resources :invitations, :controller => 'poll/invitations', :collection => {:search => :get, :create_multiple => :post}

    polls.resources :answers, :controller => 'poll/answers'

    polls.resources :votes, :controller => 'poll/votes'

    polls.resources :comments, :controller => 'poll/comments'

  end

  #
  # guild
  #
  map.resources :guilds, 
                :controller => 'guild/guilds', 
                :collection => {:hot => :get, :recent => :get, :search => :get} do |guilds|

    guilds.resources :memberships,
                     :controller => 'guild/memberships',
                     :collection => {:search => :get},
                     :member => {:confirm_destroy => :get}

    guilds.resources :wall_messages,
                     :controller => 'guild/wall_messages'

    guilds.resources :friends,
                     :controller => 'guild/friends'

    guilds.resources :requests,
                     :controller => 'guild/requests',
                     :member => {:accept => :delete, :decline => :delete}

    guilds.resources :invitations,
                     :controller => 'guild/invitations',
                     :collection => {:create_multiple => :post, :search => :get},
                     :member => {:accept => :delete, :decline => :delete}

    guilds.resources :events,
                     :controller => 'guild/events',
                     :collection => {:search => :get}
  end

  map.resources :guild_albums,
                :controller => 'guild/album/albums'

  map.resources :guild_photos, 
                :controller => 'guild/album/photos',
                :collection => {:create_multiple => :post, :update_multiple => :put, :edit_multiple => :get},
                :member => {:confirm_destroy => :get, :cover => :post} do |photos|
    photos.resources :comments,
                     :controller => 'guild/album/comments'

    photos.resources :tags,
                     :controller => 'guild/album/tags'

    photos.resources :digs,
                     :controller => 'guild/album/digs'
  end
               
  map.resources :friend_guilds,
                :controller => 'guild/friend_guilds' 

  #
  # friends
  #
  map.resources :friends, :controller => 'friend/friends', :collection => {:search => :get} 

  map.resources :someone_friends, :controller => 'friend/someone_friends'

  map.resources :friend_requests, :controller => 'friend/requests', :member => {:accept => :delete, :destroy => :delete}

  # mailbox
  map.resources :messages, :controller => 'mailbox/messages', 
                :collection => {:read_multiple => :put, :unread_multiple => :put, :destroy_multiple => :delete}

  map.resources :notifications, :controller => 'mailbox/notifications'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
