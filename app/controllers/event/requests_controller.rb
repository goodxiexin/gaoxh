class Event::RequestsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :poster_required, :only => [:index, :accept, :decline]

  before_filter :privilege_required, :only => [:new, :create]

  def index
    @requests = @event.requests.paginate :page => params[:page], :per_page => params[:per_page]
  end

  def new
    render :action => 'new', :layout => false
  end

  def create
    @request = @event.requests.build(params[:request].merge({:participant_id => current_user.id}))
    if @request.save
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def accept
    if @request.update_attribute('status', @request.status + 2)
      render :update do |page|
        page << "alert('成功'); $('event_request_#{@request.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def decline
    @request.destroy
    render :update do |page|
      page << "facebox.close(); $('evenet_request_#{@request.id}').remove();"
    end
  end

protected

  def setup
    if ['new', 'create', 'index'].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
      @privilege = @event.privilege
    elsif ['accept', 'decline'].include? params[:action]
      @event = Event.find(params[:event_id])
      @user = @event.poster
      @privilege = @event.privilege
      @request = @event.requests.find(params[:id])
    end
  rescue
    not_found
  end

  def poster_required
    @user == current_user || not_found
  end

end

