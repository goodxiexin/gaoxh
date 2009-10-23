class Guild::RequestsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:index, :accept, :decline]

  # anyone can request to be the member of the guild

  def index
    @requests = @guild.requests.paginate :page => params[:page], :per_page => params[:per_page]
  end

  def new
    render :action => 'new', :layout => false
  end

  def create
    @request = @guild.requests.build(params[:request].merge({:user_id => current_user.id}))
    if @request.save
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def accept
    if @request.update_attribute('status', @request.status + 3)
      render :update do |page|
        page << "alert('成功'); $('guild_request_#{@request.id}').remove();"
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
      @guild = Guild.find(params[:guild_id])
      @user = @guild.poster
      @privilege = @guild.privilege
    elsif ['accept', 'decline'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.poster
      @privilege = @guild.privilege
      @request = @guild.requests.find(params[:id])
    end
  rescue
    not_found
  end

end

