class Profile::ProfilesController < ApplicationController

  layout 'user'

  before_filter :login_required, :setup

  before_filter :privilege_required

  def show
  end

  def edit
    case params[:type].to_i
    when 0
      render :partial => 'edit_basic_info'
    when 1
      render :partial => 'edit_contact_info'
    when 2
      render :partial => 'edit_game_info'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      case params[:type].to_i
      when 0
        render :partial => 'basic_info'
      when 1
        render :partial => 'contact_info'
      when 2
        render :partial => 'game_info' 
      end
    end
  end

protected

  def setup
    @user = User.find(params[:id])
    @setting = @user.privacy_setting
    @privilege = @setting.personal
  rescue
    not_found
  end

end
