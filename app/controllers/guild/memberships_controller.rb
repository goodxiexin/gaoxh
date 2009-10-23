class Guild::MembershipsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :update, :destroy]

  def index
    if params[:type].to_i == 0
      @members = @guild.members.paginate :page => params[:page], :per_page => 10
    else
      @members = @guild.veterans.paginate :page => params[:page], :per_page => 10
    end
  end

  def edit
    render :action => 'edit', :layout => false  
  end
  
  def update
    @old_status = @membership.status
    if @membership.update_attributes(params[:membership])
      render :update do |page|
        page << "facebox.close();"
        if @old_status != @membership.status
          page << "$('membership_#{@membership.id}').remove();"
        end
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = '错误'"
      end
    end 
  end

  def destroy
    @membership.destroy
    render :update do |page|
      page << "$('member_#{@membership.user_id}').remove();"
    end
  end

  def search
    if params[:type].to_i == 0
      @members = @guild.normal_memberships
    else
      @members = @guild.veteranships
    end
    @members = @members.find_all {|m| m.login.include?(params[:key]) }.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    @remote = {:update => 'members', :url => {:action => 'search', :type => params[:type], :key => params[:key]}}
    render :partial => 'member_items', :object => @members
  end
 
protected

  def setup
    if ['index', 'search'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
      @membership = @guild.memberships.find(params[:id])
    end
  rescue
    not_found
  end

end
