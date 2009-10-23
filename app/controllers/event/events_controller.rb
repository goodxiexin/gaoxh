class Event::EventsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :update, :destroy]

  def index
    if params[:game_id].blank?
      @events = @user.events.paginate :page => params[:page], :per_page => 5
    else
      @events = @user.events.find(:all, :conditions => {:game_id => params[:game_id]}).paginate :page => params[:page], :per_page => 5
    end
  end

  def show
    @participation = @event.participations.find_by_participant_id(current_user.id)
    @album = @event.album
    @comments = @event.comments.user_viewable(current_user.id).paginate :page => params[:page], :per_page => 10
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event].merge({:poster_id => current_user.id}))
    if @event.save
      redirect_to new_event_invitation_url(@event)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(params[:event])
      redirect_to event_url(@event)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event.destroy
    render :update do |page|
      page.redirect_to events_url
    end
  end  

  def hot
    @events = Event.hot(params[:game_id]).paginate :page => params[:page], :per_page => 5
  end

  def recent
    @events = Event.recent(params[:game_id]).paginate :page => params[:page], :per_page => 5  
  end

  def upcoming
    if params[:game_id].blank?
      @events = @user.upcoming_events.paginate :page => params[:page], :per_page => 5
    else
      @events = @user.upcoming_events.find(:all, :conditions => {:game_id => params[:game_id]}).paginate :page => params[:page], :per_page => 5
    end
  end

  def participated
    if params[:game_id].blank?
      @events = @user.participated_events.paginate :page => params[:page], :per_page => 5
    else
      @events = @user.participated_events.find(:all, :conditions => {:game_id => params[:game_id]}).paginate :page => params[:page], :per_page => 5
    end
  end

  def search
    case params[:type].to_i
    when 0
      events = current_user.upcoming_events
    when 1
      events = Event.find(:all, :order => "participations_count DESC")
    when 2
      events = Event.find(:all, :order => "created_at DESC")
    when 3
      events = current_user.past_events
    end
    @events = events.find_all do |e| 
      e.poster.login.include?(params[:key]) || e.title.include?(params[:key]) || e.game.name.include?(params[:key]) || e.game_server.name.include?(params[:key]) || (e.game_area.blank? ? true : e.game_area.name.include?(params[:key]))
    end.paginate :page => params[:page], :per_page => 5
    @remote = {:update => 'events', :url => {:action => 'search', :controller => 'event/events', :type => params[:type], :key => params[:key]}}
    render :partial => 'event/events', :object => @events
  end

protected

  def setup
    if ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @user = current_user
      @event = Event.find(params[:id])
    elsif ['index', 'hot', 'recent', 'upcoming', 'participated'].include? params[:action]
      @user = User.find(params[:id])
    elsif ['new', 'create'].include? params[:action]
      @user = current_user
    end
  rescue
    not_found
  end

end
